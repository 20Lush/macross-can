# --- Project Definition ---
cmake_minimum_required(VERSION 3.15)
project(macross-can VERSION 1.0.0 LANGUAGES C CXX)

# --- Set C Standard ---
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)

# --- Toolchain Configuration ---
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cmake/arm-none-eabi-gcc.cmake)

get_filename_component(CMAKE_C_COMPILER_DIR ${CMAKE_C_COMPILER} DIRECTORY)

# --- CMSIS DSP ---
file(GLOB_RECURSE CMSIS_DSP_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/lib/CMSIS-DSP/Source/*.c)
list(FILTER CMSIS_DSP_SOURCES EXCLUDE REGEX ".*_neon.*.c")
add_library(CMSIS-DSP STATIC ${CMSIS_DSP_SOURCES})
set_target_properties(CMSIS-DSP PROPERTIES OUTPUT_NAME "arm_cortexM7lfsp_math")
target_compile_definitions(CMSIS-DSP PUBLIC ARM_MATH_CM7)
target_include_directories(CMSIS-DSP PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/CMSIS-DSP/Include
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/CMSIS_5/CMSIS/Core/Include
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/CMSIS-DSP/PrivateInclude
)

# --- Cores Library ---
set(CORES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/lib/cores/teensy4)
file(GLOB CORES_C_SOURCES "${CORES_DIR}/*.c")
file(GLOB CORES_CXX_SOURCES "${CORES_DIR}/*.cpp")
file(GLOB CORES_ASM_SOURCES "${CORES_DIR}/*.S")
list(FILTER CORES_CXX_SOURCES EXCLUDE REGEX "main\\.cpp$")

add_library(cores STATIC
    ${CORES_C_SOURCES}
    ${CORES_CXX_SOURCES}
    ${CORES_ASM_SOURCES}
)

target_compile_definitions(cores PUBLIC
    __IMXRT1062__
    ARDUINO=10813
    TEENSYDUINO=159
    ARDUINO_TEENSY40
    F_CPU=600000000
    USB_SERIAL
    LAYOUT_US_ENGLISH
)

set(CPU_FLAGS -mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard -mlong-calls)
target_compile_options(cores PUBLIC ${CPU_FLAGS})

set_source_files_properties(${CORES_CXX_SOURCES} PROPERTIES
    COMPILE_FLAGS "-std=gnu++17 -fno-exceptions -fpermissive -fno-rtti -Wno-error=narrowing"
)

target_include_directories(cores PUBLIC ${CORES_DIR})

# --- Add Subdirectories ---
add_subdirectory(src)

# --- Executable Definition ---
add_executable(${CMAKE_PROJECT_NAME}.elf
    $<TARGET_OBJECTS:main_obj>
)

target_link_libraries(${CMAKE_PROJECT_NAME}.elf PRIVATE -Wl,--whole-archive cores -Wl,--no-whole-archive CMSIS-DSP c gcc m)
target_include_directories(${CMAKE_PROJECT_NAME}.elf PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib/cores/teensy4)

# --- Linker Settings ---
target_link_options(${CMAKE_PROJECT_NAME}.elf PRIVATE
    -T${CMAKE_CURRENT_SOURCE_DIR}/lib/cores/teensy4/imxrt1062.ld
    -Wl,--gc-sections
    -Wl,--defsym=__dso_handle=0
    -Wl,--defsym=_init=0
    -nostdlib
    -nostartfiles
)

# --- Generate Hex and Bin files ---
add_custom_command(TARGET ${CMAKE_PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${CMAKE_PROJECT_NAME}.elf ${CMAKE_PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary ${CMAKE_PROJECT_NAME}.elf ${CMAKE_PROJECT_NAME}.bin
    COMMENT "Generating .hex and .bin files"
)

# --- Linter Target ---
find_program(CLANG_TIDY_EXE clang-tidy)
if(CLANG_TIDY_EXE)
    file(GLOB_RECURSE APP_SOURCES "src/*.c")
    add_custom_target(lint
        COMMAND ${CLANG_TIDY_EXE}
        ${APP_SOURCES}
        --
        -I${CMAKE_CURRENT_SOURCE_DIR}/include
        -I${CMAKE_CURRENT_SOURCE_DIR}/lib/cores/teensy4
        -I${CMAKE_CURRENT_SOURCE_DIR}/lib/CMSIS-DSP/Include
        -I${CMAKE_CURRENT_SOURCE_DIR}/lib/CMSIS_5/CMSIS/Core/Include
        -D__IMXRT1062__
        -DARDUINO=10813
        -DTEENSYDUINO=159
        -DARDUINO_TEENSY40
        -DF_CPU=600000000
        -DUSB_SERIAL
        -DLAYOUT_US_ENGLISH
        -target arm-none-eabi
        -mcpu=cortex-m7
        COMMENT "Running clang-tidy..."
    )
    message(STATUS "clang-tidy found. 'lint' target is available.")
else()
    message(WARNING "clang-tidy not found. 'lint' target is not available.")
endif()
