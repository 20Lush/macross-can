# Macross-CAN: Teensy 4.0 CAN-FD to USB-Serial Dongle

This repository contains the firmware for a hardware prototype that uses a Teensy 4.0 to create a high-speed CAN-FD to USB-Serial dongle.

The project is written in C99 and uses CMake for the build system. It is designed to be developed without the Arduino library, relying instead on the NXP MCUXpresso SDK for hardware abstraction.

## Dependencies

This project requires the following tools to be installed on your system and available in your system's PATH.

1.  **Git**: For cloning the repository.
2.  **CMake**: The build system generator. Download from the [official CMake website](https://cmake.org/download/).
3.  **ARM GCC Toolchain**: The compiler for the Teensy microcontroller. Download the latest `AArch32 bare-metal target` version from the [ARM Developer website](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads).
4.  **MinGW-w64**: Provides the `make` utility (`mingw32-make.exe`). The easiest way to install this on Windows is via the **MSYS2** installer. Follow the instructions at [msys2.org](https://www.msys2.org/), and once installed from the MSYS2 terminal, run `pacman -S mingw-w64-x86_64-toolchain` and `pacman -S make`.
5.  **Teensy Loader CLI**: The tool for flashing firmware to the Teensy. Download this from github: [PaulStoffregen / teensy_loader_cli](https://github.com/PaulStoffregen/teensy_loader_cli/releases).

Ensure that the executables for all these tools are available in your system's PATH.

## Getting Started

1.  **Clone the repository:**
    ```powershell
    git clone --recursive https://your-repo-url/macross-can.git
    cd macross-can
    ```

2.  **Build the firmware:**
    Run the following command in a PowerShell terminal:
    ```powershell
    .\project.ps1 -build
    ```

3.  **Flash the firmware:**
    Put your Teensy 4.0 into bootloader mode and run:
    ```powershell
    .\project.ps1 -flash
    ```

## Project Structure

```
.
├── build/                # Build output (ignored by Git)
├── include/              # Project-specific header files
├── lib/                  # Git submodules for external libraries (e.g., NXP SDK)
├── src/                  # Main source code
├── tools/                # Helper scripts and tools
│   └── arm-none-eabi-gcc.cmake
├── .gitignore
├── CMakeLists.txt        # Main CMake build script
├── project.ps1           # PowerShell helper script
└── README.md
