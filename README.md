# Macross-CAN: Teensy 4.0 CAN-FD to USB-Serial Dongle

[![Format](https://github.com/20Lush/macross-can/actions/workflows/format.yml/badge.svg)](https://github.com/20Lush/macross-can/actions/workflows/format.yml)
[![Lint](https://github.com/20Lush/macross-can/actions/workflows/lint.yml/badge.svg)](https://github.com/20Lush/macross-can/actions/workflows/lint.yml)

This repository contains the firmware for a hardware prototype that uses a Teensy 4.0 to create a high-speed CAN-FD to USB-Serial dongle.

The project is written in C99 and uses CMake for the build system. It is designed to be developed without the Arduino library, relying instead on low-level libraries and direct hardware abstraction.

## Dependencies

This project requires the following tools to be installed on your system and available in your system's PATH.

1.  **Git**: For cloning the repository. The installer typically handles this, but ensure both `<GIT_INSTALL_PATH>\cmd` and `<GIT_INSTALL_PATH>\bin` are in your system's PATH.
2.  **CMake**: The build system generator. Download from the [official CMake website](https://cmake.org/download/). Ensure its `bin` directory is added to your system's PATH.
3.  **ARM GCC Toolchain**: The compiler for the Teensy microcontroller. Download the latest `AArch32 bare-metal target` version from the [ARM Developer website](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads). After installation, add its `bin` directory to your system's PATH.
4.  **MinGW-w64**: Provides the `make` utility. The easiest way to install this on Windows is via the **MSYS2** installer. Follow the instructions at [msys2.org](https://www.msys2.org/), and once installed from the MSYS2 terminal, run `pacman -S mingw-w64-x86_64-toolchain` and `pacman -S make`. After installation, you should add the following directories to your system's PATH:
    *   `<MSYS2_INSTALL_PATH>\mingw64\bin`
    *   `<MSYS2_INSTALL_PATH>\usr\bin`
5.  **Teensy Loader CLI**: The tool for flashing firmware to the Teensy. Download this from github: [PaulStoffregen / teensy_loader_cli](https://github.com/PaulStoffregen/teensy_loader_cli/releases).
6.  **Clang Tools (`clang-tidy` and `clang-format`)**: Provides linting and code formatting capabilities. These are also best installed via **MSYS2**. From the MSYS2 UCRT64 terminal, run:
    ```bash
    pacman -Syu
    pacman -S mingw-w64-ucrt-x86_64-clang-tools-extra
    ```
    After installation, you must add the MSYS2 UCRT64 binary directory to your system's PATH. This is typically located at `<MSYS2_INSTALL_PATH>\ucrt64\bin`.

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
*   `.\project.ps1 -lint`: Runs `clang-tidy` to analyze the code for potential bugs.
*   `.\project.ps1 -format`: Runs `clang-format` to automatically format the code.

You can combine commands, for example, to do a clean build: `.\project.ps1 -clean; .\project.ps1 -build`

## VSCode Integration

This repository includes a `.vscode/tasks.json` file that integrates the project's build and flash commands directly into the VSCode interface.

To use these tasks, open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`) and select "Tasks: Run Task". You will see the following options:

*   **build**: Compiles the firmware.
*   **clean**: Deletes the build directory.
*   **clean build**: Performs a clean build. This is the default build task and can be run with the shortcut `Ctrl+Shift+B` or `Cmd+Shift+B`.
*   **flash**: Flashes the compiled firmware to the Teensy.

The build tasks are configured with a `$gcc` problem matcher, which will parse compiler errors and warnings and display them in the "Problems" panel in VSCode.

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
