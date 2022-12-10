#ifndef FONCTION6_H
#define FONCTION6_H
#include <stdint.h>
#include "system.h"
#include "io.h"

void verin_freq(uint32_t frequence, uint32_t duty, uint32_t freq_clk_fpga);
void verin_butee(uint32_t butee_d, uint32_t butee_g);
void verin_config(uint8_t raz_n, uint8_t en_pwm, uint8_t sens_rotation);
uint32_t read_angle();
uint32_t read_f_butee_d();
uint32_t read_f_butee_g();

#endif /* FONCTION6_H */
