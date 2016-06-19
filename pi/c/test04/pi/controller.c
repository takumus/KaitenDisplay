#include <wiringPi.h>
#include <stdio.h>
#include <pthread.h>
#include <vector> 
#include <string>
#include <string.h>
#include <iostream>
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
int rpMicros = 1000000;//1回転1秒(1000000マイクロ秒)
int dataLength = 1;
int dataMicros;

void update() {
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
			status = READING;
			continue;
		}else if(head == '>'){
			//読み込み終了にする
			status = COMPLETE;
			//データ数が変わったので。
			update();
			continue;
		}else if(head == 's'){
			cin >> rpMicros;
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
	while(1){
	}
	return 0;
}
