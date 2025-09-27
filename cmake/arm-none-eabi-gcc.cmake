# --- CMake Toolchain File for ARM Embedded GCC ---

# --- Target System ---
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# --- Compilers ---
find_program(CMAKE_C_COMPILER arm-none-eabi-gcc)
find_program(CMAKE_CXX_COMPILER arm-none-eabi-g++)
find_program(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
find_program(CMAKE_AR arm-none-eabi-ar)
find_program(CMAKE_OBJCOPY arm-none-eabi-objcopy)
find_program(CMAKE_OBJDUMP arm-none-eabi-objdump)
find_program(CMAKE_SIZE arm-none-eabi-size)

# --- Compiler Flags ---
set(CPU_FLAGS "-mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard")
set(CMAKE_C_FLAGS "${CPU_FLAGS} -Wall -Wextra -g3 -O2" CACHE INTERNAL "C Compiler Flags")
set(CMAKE_CXX_FLAGS "${CPU_FLAGS} -Wall -Wextra -g3 -O2" CACHE INTERNAL "C++ Compiler Flags")
set(CMAKE_ASM_FLAGS "${CPU_FLAGS} -x assembler-with-cpp -g3" CACHE INTERNAL "ASM Compiler Flags")

# --- Linker Flags ---
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -nostdlib" CACHE INTERNAL "Linker Flags")

# --- Search Paths ---
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
