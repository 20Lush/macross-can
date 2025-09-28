#include "main.h"
#include <Arduino.h>

const int pin_led = LED_BUILTIN;

// This function runs once at startup.
void setup()
{
	pinMode(pin_led, OUTPUT);
   digitalWriteFast(pin_led, HIGH);
}

// This function runs repeatedly after setup().
void loop()
{
	digitalWriteFast(pin_led, HIGH);
	delay(100);
	digitalWriteFast(pin_led, LOW);
	delay(100);
}
