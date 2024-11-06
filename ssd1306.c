#include "ssd1306.h"
#include "hardware/i2c.h"

const uint8_t font5x7[96][5] = {
    {0x00, 0x00, 0x00, 0x00, 0x00}, // Espacio
    {0x7E, 0x11, 0x11, 0x11, 0x7E}, // E
    {0x7F, 0x09, 0x09, 0x09, 0x06}, // m
    {0x3E, 0x41, 0x41, 0x41, 0x22}, // i
    {0x7F, 0x48, 0x48, 0x48, 0x30}, // L
    {0x3E, 0x41, 0x41, 0x41, 0x3E}, // a
    {0x7C, 0x14, 0x14, 0x14, 0x08}, // r
};

void ssd1306_init() {
    uint8_t init_sequence[] = {
        0xAE, 0xD5, 0x80, 0xA8, 0x3F, 0xD3, 0x00, 0x40,
        0x8D, 0x14, 0x20, 0x00, 0xA1, 0xC8, 0xDA, 0x12,
        0x81, 0xCF, 0xD9, 0xF1, 0xDB, 0x40, 0xA4, 0xA6, 0xAF
    };
    for (int i = 0; i < sizeof(init_sequence); i++) {
        i2c_write_blocking(I2C_PORT, SSD1306_I2C_ADDR, &init_sequence[i], 1, false);
    }
}

void ssd1306_clear() {
    for (uint8_t page = 0; page < 8; page++) {
        uint8_t page_setup[] = {0xB0 | page, 0x00, 0x10};
        i2c_write_blocking(I2C_PORT, SSD1306_I2C_ADDR, page_setup, 3, false);
        
        uint8_t empty_line[SSD1306_WIDTH] = {0x00};
        i2c_write_blocking(I2C_PORT, SSD1306_I2C_ADDR, empty_line, SSD1306_WIDTH, false);
    }
}

void ssd1306_display_text(const char *text, uint8_t line) {
    uint8_t cmd[] = {0xB0 + line, 0x00, 0x10};
    i2c_write_blocking(I2C_PORT, SSD1306_I2C_ADDR, cmd, 3, false);

    while (*text) {
        char ch = *text++;
        if (ch < 32 || ch > 127) ch = 32;

        for (int i = 0; i < 5; i++) {
            uint8_t column = font5x7[ch - 32][i];
            i2c_write_blocking(I2C_PORT, SSD1306_I2C_ADDR, &column, 1, false);
        }

        uint8_t spacer = 0x00;
        i2c_write_blocking(I2C_PORT, SSD1306_I2C_ADDR, &spacer, 1, false);
    }
}

void ssd1306_display_name() {
    ssd1306_clear();
    ssd1306_display_text("Emi Lar", 0);
}