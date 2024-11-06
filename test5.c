#include <stdio.h>
#include "ssd1306.h"
#include "pico/stdlib.h"
#include "hardware/i2c.h"

int main() {
    stdio_init_all();
    
    // Configuración del puerto I2C
    i2c_init(I2C_PORT, 400 * 1000);
    gpio_set_function(0, GPIO_FUNC_I2C);  // SDA en GP0
    gpio_set_function(1, GPIO_FUNC_I2C);  // SCL en GP1
    gpio_pull_up(0);
    gpio_pull_up(1);

    // Inicializar OLED y mostrar texto
    ssd1306_init();
    ssd1306_display_name();
    
    while (1) {
        // Mantener el bucle para evitar que el programa termine
        sleep_ms(1000);
    }

    return 0;
}
