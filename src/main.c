#include "main.h"
#include "core_pins.h"

const int pin_led = LED_BUILTIN;

#define DELAY_INTERVAL 250

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
   delay(DELAY_INTERVAL);
   digitalWriteFast(pin_led, LOW);
   delay(DELAY_INTERVAL);
}
