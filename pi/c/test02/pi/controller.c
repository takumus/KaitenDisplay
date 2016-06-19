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
		string str;
		cin >> str;
		int len = str.length();
		while(len < LED_LENGTH){
			str+='0';
			len ++;
		}
		sWrite( DATAPIN, CLOCKPIN, LED_LENGTH, str);
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
	while(1){
	}
	return 0;
}
