#include <wiringPi.h>
#include <stdio.h>
#include <pthread.h>
#include <vector> 
#include <string>
#include <string.h>
#include <iostream>
using namespace std;

#define DATAPIN  5
#define LATCHPIN 4
#define CLOCKPIN 1
#define LED_LENGTH 48

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
			while(len < LED_LENGTH){
				str+='0';
				len ++;
			}

			addLine(str, 1);
		}
		length = data.size();
	}
	return NULL;
}
string getFillStr(char value)
{
	string str = "";
	for(int i = 0; i < LED_LENGTH; i ++){
		str += value;
	}
	return str;
}
void initDefaultData()
{
	string str;
	string tmpStr;
	//だんだん積み重なる君
	for(int i = 0; i < LED_LENGTH; i ++){
		str = getFillStr('0');
		int ii;
		for(ii = 0; ii < i; ii++){
			str[ii] = '1';
		}
		tmpStr = str;
		addLine(str, 1);
		for(ii = LED_LENGTH - 1; ii >= i; ii--){
			str = tmpStr;
			str[ii] = '1';
			addLine(str, 1);
		}
	}
	//両端から消えてゆく
	str = getFillStr('1');
	for(int i = 0; i < LED_LENGTH/2; i ++){
		str[i] = '0';
		str[LED_LENGTH - 1 - i] = '0';
		addLine(str, 3);
	}
	//両端から来る
	str =  getFillStr('0');
	for(int i = 0; i < LED_LENGTH/2; i ++){
		str[i] = '1';
		str[LED_LENGTH - 1 - i] = '1';
		addLine(str, 3);
	}
	//両端から消えてゆく
	str = getFillStr('1');
	for(int i = 0; i < LED_LENGTH/2; i ++){
		str[i] = '0';
		str[LED_LENGTH - 1 - i] = '0';
		addLine(str, 3);
	}
	//両端から来る
	str =  getFillStr('0');
	for(int i = 0; i < LED_LENGTH/2; i ++){
		str[i] = '1';
		str[LED_LENGTH - 1 - i] = '1';
		addLine(str, 3);
	}
	//両端から消えてゆく
	str = getFillStr('1');
	for(int i = 0; i < LED_LENGTH/2; i ++){
		str[i] = '0';
		str[LED_LENGTH - 1 - i] = '0';
		addLine(str, 3);
	}
	int n = 5;
	//だんだん積み重なる君1こ飛ばし
	for(int i = 0; i < LED_LENGTH; i +=n){
		str = getFillStr('0');
		int ii;
		for(ii = 0; ii < i; ii+=n){
			str[ii] = '1';
		}
		tmpStr = str;
		addLine(str, 3);
		for(ii = LED_LENGTH-1; ii >= i; ii--){
			str = tmpStr;
			str[ii] = '1';
			addLine(str, 3);
		}
	}
	//１こ飛ばし点滅
	for(int i = 0; i < 64; i ++){
		for(int ii = 0; ii < LED_LENGTH; ii++){
			str[ii] = ((i+ii)%n==0)?'1':'0';
		}
		addLine(str, 3);
	}
	//点滅
	for(int i = 0; i < LED_LENGTH; i ++){
		for(int ii = 0; ii < LED_LENGTH; ii++){
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
		if(length == 0)sWrite( DATAPIN, CLOCKPIN, LED_LENGTH, getFillStr('0'));
		for(int i = 0; i < length; i ++){
			sWrite( DATAPIN, CLOCKPIN, LED_LENGTH, data[i]);
			delayMicroseconds(interval);
		}
	}
	return 0;
}
