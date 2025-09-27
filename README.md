# Macross-CAN: Teensy 4.0 CAN-FD to USB-Serial Dongle

This repository contains the firmware for a hardware prototype that uses a Teensy 4.0 to create a high-speed CAN-FD to USB-Serial dongle.

The project is written in C99 and uses CMake for the build system. It is designed to be developed without the Arduino library, relying instead on low-level libraries and direct hardware abstraction.

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
    git clone https://github.com/20Lush/macross-can.git
    cd macross-can
    ```

2.  **Initialize Submodules:**
    Run the following command in a PowerShell terminal to pull in the required libraries:
    ```powershell
    .\project.ps1 -submodules
    ```

3.  **Build the firmware:**
    ```powershell
    .\project.ps1 -build
    ```

4.  **Flash the firmware:**
    Put your Teensy 4.0 into bootloader mode and run:
    ```powershell
    .\project.ps1 -flash
    ```

## Project Workflow

All project tasks are managed through the `project.ps1` PowerShell script.

*   `.\project.ps1 -build`: Compiles the firmware.
*   `.\project.ps1 -clean`: Deletes the build directory.
*   `.\project.ps1 -flash`: Flashes the compiled firmware to the Teensy.
*   `.\project.ps1 -submodules`: Initializes and updates Git submodules.

You can combine commands, for example, to do a clean build: `.\project.ps1 -clean; .\project.ps1 -build`

## Project Structure

```
.
├── build/                # Build output (ignored by Git)
├── cmake/                # CMake helper scripts
│   └── arm-none-eabi-gcc.cmake # Toolchain file for cross-compilation
├── include/              # Project-specific header files
├── lib/                  # Git submodules for external libraries
├── src/                  # Main source code
├── .gitignore
├── .gitmodules
├── CMakeLists.txt        # Main CMake build script
├── project.ps1           # PowerShell helper script
└── README.md
