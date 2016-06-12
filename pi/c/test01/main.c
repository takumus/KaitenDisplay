#include <wiringPi.h>
#include <stdio.h>
#include <pthread.h>
#include <vector> 
#include <string>
#include <string.h>
#include <iostream>
using namespace std;

#define DATAPIN		0
#define LATCHPIN	2
#define CLOCKPIN	3

vector<string> data{
	"1000000000000000",
	"1100000000000000"
};
int interval = 100000;
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

			data.push_back(str);
		}
		length = data.size();
	}
	return NULL;
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
	printf("hello\n");
	length = data.size();
	while(1){
		for(int i = 0; i < length; i ++){
			sWrite( DATAPIN, CLOCKPIN, 16, data[i]);
			delayMicroseconds(interval);
		}
	}
	return 0;
}
