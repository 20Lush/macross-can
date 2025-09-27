# --- Object Library for Main Application ---

add_library(main_obj OBJECT
    main.c
)

# Flags must be in a list for target_compile_options
set(CPU_FLAGS -mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard)
target_compile_options(main_obj PRIVATE ${CPU_FLAGS})

target_include_directories(main_obj PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/../include
    ${CMAKE_CURRENT_SOURCE_DIR}/../lib/cores/teensy4
)

target_compile_definitions(main_obj PRIVATE
    __IMXRT1062__
    ARDUINO=10813
    TEENSYDUINO=159
    ARDUINO_TEENSY40
    F_CPU=600000000
    USB_SERIAL
    LAYOUT_US_ENGLISH
)
