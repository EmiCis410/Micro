#ifndef SSD1306_H
#define SSD1306_H

#include <stdint.h>

// Definición del puerto I2C y la dirección de la pantalla SSD1306
#define I2C_PORT i2c0
#define SSD1306_I2C_ADDR 0x3C  // Dirección I2C estándar para SSD1306
#define SSD1306_WIDTH 128
#define SSD1306_HEIGHT 64

// Prototipos de funciones
void ssd1306_init();
void ssd1306_clear();
void ssd1306_display_text(const char *text, uint8_t line);
void ssd1306_display_name();

#endif // SSD1306_H

