#include <wiringPi.h>
#include <stdio.h>
#include <pthread.h>
#include <vector> 
#include <string>
#include <string.h>
#include <iostream>
#include <time.h>
#include <sys/time.h>
#include <sys/resource.h>

using namespace std;

#define DATAPIN  0
#define LATCHPIN 2
#define CLOCKPIN 3
#define LED_LENGTH 48

#define READING   0
#define COMPLETE  1
#define NONE      2
vector<string> data{};
int status = NONE;
unsigned int rpMicros = 1000000;//1回転1秒(1000000マイクロ秒)
int dataLength = 1;
unsigned int dataMicros;

int animateIndex = 0;

void update()
{
	//一回転の時間をデータ数で割って１データを表示する時間を求めるのです
	dataMicros = rpMicros / dataLength;
}
void* thread( void* args )
{

	while( 1 ){
		string str;
		char head;

		cin >> str;
		head = str[0];

		if(head == '<'){
			//読み込み中にする
			printf("begin data\n");
			status = READING;
			data.clear();
			continue;
		}else if(head == '>'){
			//読み込み終了にする
			printf("end data\n");
			status = COMPLETE;
			dataLength = data.size();
			//データ数が変わったので。
			update();
			continue;
		}else if(head == 's'){
			status = NONE;
			cin >> rpMicros;
			status = COMPLETE;
			//１回転あたりの時間が変わったので。
			update();
		}

		if(status == READING){
			data.push_back(str);
		}else if(status == COMPLETE){
			//何もしない
		}else if(status == NONE){
			//何もしない
		}
		//write( DATAPIN, CLOCKPIN, LED_LENGTH, str);
	}
	return NULL;
}

void write(string val)
{
	digitalWrite(LATCHPIN, 0);
	for(int i = 0; i < LED_LENGTH; i++ )
	{
		digitalWrite(DATAPIN, val[i] == '1');
		digitalWrite(CLOCKPIN, 1);
		digitalWrite(CLOCKPIN, 0);
	}
	digitalWrite(LATCHPIN, 1);
}
double getrusage_sec()
{
    struct rusage t;
    struct timeval tv;
    getrusage(RUSAGE_SELF, &t);
    tv = t.ru_utime;
    return tv.tv_sec + tv.tv_usec * 1e-6;
}
void animating()
{
	int mcount = 0;
	struct timespec gettime_now;
	long pt = 0;
	while(1){
		if(status != COMPLETE) continue;
		struct timeval start, stop;
		gettimeofday(&start, NULL);
		long nt = (long)(start.tv_sec*1000000ULL+start.tv_usec);
		if(pt + dataMicros < nt ){
			printf(":%d\n", animateIndex);
			pt = nt;
			if(animateIndex >= dataLength){
				animateIndex = 0;
			}
			write(data[animateIndex]);
			animateIndex ++;
		}
	}
}
int main(void)
{
	pthread_t th;
	pthread_create( &th, NULL, thread, (void *)NULL );

	if(wiringPiSetup() == -1){
		printf("error wiringPi setup\n");
		return 1;
	}
	pinMode(DATAPIN, OUTPUT);
	pinMode(LATCHPIN, OUTPUT);
	pinMode(CLOCKPIN, OUTPUT);

	animating();
	return 0;
}
