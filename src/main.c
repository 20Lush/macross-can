#include "main.h"
#include "core_pins.h"

const int pin_led = LED_BUILTIN;

#define DELAY_INTERVAL 250

int main(void)
{
   // Setup
   pinMode(pin_led, OUTPUT);
   digitalWriteFast(pin_led, HIGH);

   // Loop
   while (1)
   {
      digitalWriteFast(pin_led, HIGH);
      delay(DELAY_INTERVAL);
      digitalWriteFast(pin_led, LOW);
      delay(DELAY_INTERVAL);
   }

   return 0; // Should not reach here
}
