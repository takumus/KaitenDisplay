#include <wiringPi.h>
#include <stdio.h>

#define DATAPIN		0
#define LATCHPIN	2
#define CLOCKPIN	3

unsigned long a[]= {
	0b1000000000000001,
	0b0100000000000010,
	0b0010000000000100,
	0b0001000000001000,
	0b0000100000010000,
	0b0000010000100000,
	0b0000001001000000,
	0b0000000110000000,
	0b0000000110000000,
	0b0000001111000000,
	0b0000011111100000,
	0b0000111111110000,
	0b0001111111111000,
	0b0011111111111100,
	0b0111111111111110,
	0b1111111111111111,
	0b1111111111111111,
	0b0111111111111110,
	0b0011111111111100,
	0b0001111111111000,
	0b0000111111110000,
	0b0000011111100000,
	0b0000001111000000,
	0b0000000110000000,
	0b0000000110000000,
	0b0000001001000000,
	0b0000010000100000,
	0b0000100000010000,
	0b0001000000001000,
	0b0010000000000100,
	0b0100000000000010
};
void sWrite( int dataPin, int clockPin, int bit, unsigned long val )
{
	digitalWrite(LATCHPIN, 0);
	int i;
	for(i = 0; i < bit; i++ )
	{
		digitalWrite(dataPin, ((val>>i) & 1L));
		digitalWrite(clockPin, 1);
		digitalWrite(clockPin, 0);
	}
	digitalWrite(LATCHPIN, 1);
}

int main(void)
{
	if(wiringPiSetup() == -1){
		printf("error wiringPi setup\n");
		return 1;
	}
	pinMode(DATAPIN, OUTPUT);
	pinMode(LATCHPIN, OUTPUT);
	pinMode(CLOCKPIN, OUTPUT);
	int i;
	while(1){
		for(i = 0; i< 31; i ++){
			sWrite( DATAPIN, CLOCKPIN, 16, a[i]);
			delayMicroseconds(10000);
		}
	}
	return 0;
}
