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
//デバッグLEDピン
#define DEBUGLEDPIN 10

//LED個数
#define LED_LENGTH 48

//各ステータス
#define READING   0
#define COMPLETE  1
#define NONE      2

//受信フレーム列
vector<vector<string>> frameList;
//フレーム列の長さ
int frameListLength = 1;
//フレーム列のインデックス
int frameListIndex = 0;
//フレーム列の切り替え速度
int frameListInterval = 1000000;

//現在のフレーム
vector<string> lineList;
//ラインのインデックス
int lineListIndex = 0;
//ラインの長さ
int lineListLength = 0;

//現在ステータス
int status = NONE;
//1回転の秒数(マイクロ秒)
unsigned int rpMicros = 1000000;
//1ラインの表示時間
unsigned int lineMicros = 100000;

unsigned long getTime()
{
	timeval time;
	gettimeofday(&time, NULL);
	return (time.tv_sec * 1000000ULL + time.tv_usec);
}

void update()
{
	//一回転の時間をライン数で割って表示する時間を求めるのです
	lineMicros = rpMicros / lineListLength;
	lineListIndex = 0;
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
//コマンド受付用スレッド
void* thread_command(void* args)
{
	while(1){
		string str;
		cin >> str;
		if(str == "begin"){
			status = READING;
			cout << "+データ" << endl;
			cin >> lineListLength;
			cout << "	-ライン数   > " << lineListLength << "ライン" << endl;
			cin >> frameListLength;
			cout << "	-フレーム数 > " << frameListLength << "フレーム" << endl;
			cin >> frameListInterval;
			cout << "	-フレーム秒 > " << frameListInterval << "μs" << endl;
			cout << "	+フレーム" << endl;
			string tmpLine;
			frameList.clear();
			//全フレーム収集
			for(int frameListIndex = 0; frameListIndex < frameListLength; frameListIndex ++){
				//全ライン収集
				vector<string> tmpLineList;
				for(int lineListIndex = 0; lineListIndex < lineListLength; lineListIndex ++){
					cin >> tmpLine;
					tmpLineList.push_back(tmpLine);
				}
				frameList.push_back(tmpLineList);
				cout << "		-フレーム" << (frameListIndex+1) << "/" << frameListLength << endl;
			}
			cout << "	-フレーム" << endl;
			cout << "-データ" << endl;
			status = COMPLETE;
		}
	}
	return NULL;
}
//回転速度検知用スレッド
void* thread_rotationTimer(void* args)
{
	unsigned long pt = 0, nt = 0, diff;
	int prevStatus = 1;
	while(1){
		int status = digitalRead(INPUTPIN);
		if(status == prevStatus) continue;
		prevStatus = status;
		if(status == 0){
			nt = getTime();
			diff = nt - pt;
			if(diff > 100000){
				pt = nt;
				//cout << diff << endl;
				rpMicros = diff;
				update();
			}
		}
	}
	return NULL;
}
//レンダリング用スレッド
void* thread_render(void* args)
{
	unsigned long pt = 0, nt = 0;
	while(1){
		if(status != COMPLETE) continue;
		nt = getTime();
		if(pt + lineMicros < nt ){
			pt = nt;
			if(lineListIndex >= lineListLength) lineListIndex = 0;
			//フレームを取得
			lineList = frameList[frameListIndex];
			digitalWrite(DEBUGLEDPIN, lineListIndex == 0);
			write(lineList[lineListIndex]);
			lineListIndex ++;
		}
	}
	return NULL;
}
//フレーム進行用スレッド
void* thread_frame(void* args)
{
	unsigned long pt = 0, nt = 0;
	while(1){
		if(status != COMPLETE) continue;
		nt = getTime();
		if(pt + frameListInterval < nt ){
			pt = nt;
			frameListIndex ++;
			if(frameListIndex >= frameListLength) frameListIndex = 0;
			//cout << frameListIndex << endl;
		}
	}
	return NULL;
}

int main(void)
{
	if(wiringPiSetup() == -1){
		return 1;
	}
	pullUpDnControl(INPUTPIN, PUD_UP);
	pinMode(INPUTPIN, INPUT);
	pinMode(DATAPIN, OUTPUT);
	pinMode(LATCHPIN, OUTPUT);
	pinMode(CLOCKPIN, OUTPUT);
	pinMode(DEBUGLEDPIN, OUTPUT);

	pthread_t _thread_rotationTimer;
	pthread_create(&_thread_rotationTimer, NULL, thread_rotationTimer, (void *)NULL);

	pthread_t _thread_frame;
	pthread_create(&_thread_frame, NULL, thread_frame, (void *)NULL);

	pthread_t _thread_render;
	pthread_create(&_thread_render, NULL, thread_render, (void *)NULL);

	pthread_t _thread_command;
	pthread_create(&_thread_command, NULL, thread_command, (void *)NULL);

	while(1){
	}
	return 0;
}
