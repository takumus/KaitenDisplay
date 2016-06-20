#include <wiringPi.h>
#include <stdio.h>
#include <pthread.h>
#include <vector> 
#include <string>
#include <string.h>
#include <iostream>
using namespace std;
vector<string> data{};
#define DATAPIN  5
#define LATCHPIN 4
#define CLOCKPIN 1

void* thread( void* args )
{	
	while( 1 ){
		string str;
		cin >> str;
		if(str[0] == 'i'){
			int len = 0;
			for(int i = 0; i < data.size(); i ++){
				len += data[i].length();
			}
			printf("%d\n", len);
			continue;
		}
		int len = str.length();
		while(len < 16){
			str+='0';
			len ++;
		}
		data.push_back(str);
	}
	return NULL;
}
int main(void)
{
	printf("hello\n");
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
