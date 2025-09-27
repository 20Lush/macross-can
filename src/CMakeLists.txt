# --- Object Library for Main Application ---

add_library(main_obj OBJECT
    main.c
)

# Flags must be in a list for target_compile_options
set(CPU_FLAGS -mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard)
target_compile_options(main_obj PRIVATE ${CPU_FLAGS})

target_include_directories(main_obj PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/../include
)
