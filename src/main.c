#include <stdint.h>
#include "usb_serial.h"

int main(void) {
    // --- Main application loop ---
    while (1) {
        // TODO: Implement CAN-FD to USB-Serial logic
        usb_serial_write("Hello, world!\r\n", 15);
    }
    return 0;
}
