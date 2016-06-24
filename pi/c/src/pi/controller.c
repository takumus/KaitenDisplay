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

//シフトレジスタ
#define CLOCKPIN 1
#define LATCHPIN 4
#define DATAPIN  5
//リードスイッチ
#define INPUTPIN 6

//LED個数
#define LED_LENGTH 48

//各ステータス
#define READING   0
#define COMPLETE  1
#define NONE      2

//受信データ
vector<string> data{};
//データの長さ
int dataLength = 1;
//データのインデックス
int dataIndex = 0;

//現在ステータス
int status = NONE;
//1回転の秒数(マイクロ秒)
unsigned int rpMicros = 1000000;
//1データの表示時間
unsigned int dataMicros;

void update()
{
	//一回転の時間をデータ数で割って１データを表示する時間を求めるのです
	dataMicros = rpMicros / dataLength;
}
void* thread_command( void* args )
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
void* thread_rotationTimer( void* args )
{
	unsigned long pt, nt;
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
void animating()
{
	unsigned long pt, nt = 0;
	while(1){
		if(status != COMPLETE) continue;
		struct time;
		gettimeofday(&time, NULL);
		nt = (time.tv_sec * 1000000ULL + time.tv_usec);
		if(pt + dataMicros < nt ){
			pt = nt;
			if(dataIndex >= dataLength) dataIndex = 0;
			write(data[dataIndex]);
			dataIndex ++;
		}
	}
}
int main(void)
{
	pthread_t _thred_command;
	pthread_create( &_thred_command, NULL, thread_command, (void *)NULL );

	pthread_t _thred_rotationTimer;
	pthread_create( &_thred_rotationTimer, NULL, thread_rotationTimer, (void *)NULL );


	if(wiringPiSetup() == -1){
		printf("error wiringPi setup\n");
		return 1;
	}
	pullUpDnControl(INPUTPIN, PUD_UP);
	pinMode(INPUTPIN, INPUT);
	pinMode(DATAPIN, OUTPUT);
	pinMode(LATCHPIN, OUTPUT);
	pinMode(CLOCKPIN, OUTPUT);

	animating();
	return 0;
}
