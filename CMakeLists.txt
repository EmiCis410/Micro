cmake_minimum_required(VERSION 3.13)
include(pico_sdk_import.cmake)
pico_sdk_init()

project(test5)

add_executable(test5
    test5.c      # Archivo principal
    ssd1306.c   # Archivo del controlador OLED
)

target_link_libraries(test5
    pico_stdlib        # Biblioteca estándar de Pico
    hardware_i2c       # Biblioteca de I2C
)

pico_enable_stdio_usb(test5 1)
pico_enable_stdio_uart(test5 0)

pico_add_extra_outputs(test5)
