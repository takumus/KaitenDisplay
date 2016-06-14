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

vector<string> data{};
int interval = 10000;
int length;
void sWrite( int dataPin, int clockPin, int bit, string val )
{
	digitalWrite(LATCHPIN, 0);
	for(int i = 0; i < bit; i++ )
	{
		digitalWrite(dataPin, val[i]=='1');
		digitalWrite(clockPin, 1);
		digitalWrite(clockPin, 0);
	}
	digitalWrite(LATCHPIN, 1);
}
void addLine(string line, int count)
{
	for(;count > 0; count --){
		data.push_back(line);
	}
}

void* thread( void* args )
{	
	while( 1 ){
		unsigned long val = 0b0000000000000000;
		string str;
		cin >> str;
		char cmd = str[0];
		if(cmd == 'c') {
			data.clear();
		}else if(cmd == 's'){
			cin >> interval;
			continue;
		}else if(cmd == 'r'){
			data.pop_back();
		}else{
			int len = str.length();
			while(len < 16){
				str+='0';
				len ++;
			}

			addLine(str, 1);
		}
		length = data.size();
	}
	return NULL;
}
void initDefaultData()
{
	string str;
	string tmpStr;
	//だんだん積み重なる君
	for(int i = 0; i < 16; i ++){
		str = "0000000000000000";
		int ii;
		for(ii = 0; ii < i; ii++){
			str[ii] = '1';
		}
		tmpStr = str;
		addLine(str, 3);
		for(ii = 15; ii >= i; ii--){
			str = tmpStr;
			str[ii] = '1';
			addLine(str, 3);
		}
	}
	//両端から消えてゆく
	str = "1111111111111111";
	for(int i = 0; i < 8; i ++){
		str[i] = '0';
		str[15 - i] = '0';
		addLine(str, 3);
	}
	//両端から来る
	str = "0000000000000000";
	for(int i = 0; i < 8; i ++){
		str[i] = '1';
		str[15 - i] = '1';
		addLine(str, 3);
	}
	//だんだん積み重なる君1こ飛ばし
	for(int i = 0; i < 16; i +=4){
		str = "0000000000000000";
		int ii;
		for(ii = 0; ii < i; ii+=4){
			str[ii] = '1';
		}
		tmpStr = str;
		addLine(str, 3);
		for(ii = 15; ii >= i; ii--){
			str = tmpStr;
			str[ii] = '1';
			addLine(str, 3);
		}
	}
	//１こ飛ばし点滅
	for(int i = 0; i < 64; i ++){
		for(int ii = 0; ii < 16; ii++){
			str[ii] = ((i+ii)%4==0)?'1':'0';
		}
		addLine(str, 3);
	}
	//点滅
	for(int i = 0; i < 16; i ++){
		for(int ii = 0; ii < 16; ii++){
			str[ii] = (i%2==0)?'1':'0';
		}
		addLine(str, 8);
	}

	//デフォデータ出力
	for(int i = 0; i < data.size(); i ++){
		printf("%s\n", data[i].c_str());
	}
}
int main(void)
{
	initDefaultData();

	pthread_t th;
	pthread_create( &th, NULL, thread, (void *)NULL );

	if(wiringPiSetup() == -1){
		printf("error wiringPi setup\n");
		return 1;
	}
	pinMode(DATAPIN, OUTPUT);
	pinMode(LATCHPIN, OUTPUT);
	pinMode(CLOCKPIN, OUTPUT);
	length = data.size();
	while(1){
		if(length == 0)sWrite( DATAPIN, CLOCKPIN, 16, "0000000000000000");
		for(int i = 0; i < length; i ++){
			sWrite( DATAPIN, CLOCKPIN, 16, data[i]);
			delayMicroseconds(interval);
		}
	}
	return 0;
}
