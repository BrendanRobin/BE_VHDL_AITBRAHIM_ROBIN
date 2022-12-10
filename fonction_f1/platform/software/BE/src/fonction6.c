#include "../inc/fonction6.h"
#include "system.h"


void verin_freq(uint32_t frequence, uint32_t duty, uint32_t freq_clk_fpga){
	frequence = freq_clk_fpga/frequence;
	duty = 500;

	IOWR_32DIRECT(AVALON_F6_0_BASE, 0, frequence);
	IOWR_32DIRECT(AVALON_F6_0_BASE, 4, duty);
}

void verin_butee(uint32_t butee_d, uint32_t butee_g){
	IOWR_32DIRECT(AVALON_F6_0_BASE, 8, butee_g);
	IOWR_32DIRECT(AVALON_F6_0_BASE, 12, butee_d);
}

void verin_config(uint8_t raz_n, uint8_t en_pwm, uint8_t sens_rotation){
	uint32_t config = 0;
	config = config | (sens_rotation << 2);
	config = config | (en_pwm << 1);
	config = config | (raz_n << 0);
	IOWR_32DIRECT(AVALON_F6_0_BASE, 16, config);
}


uint32_t read_angle() {
	uint32_t angle_barre;
	angle_barre = (IORD_16DIRECT(AVALON_F6_0_BASE, 20) & 0x0FFF);
	return angle_barre;
}

uint32_t read_f_butee_d(){
	uint32_t butee_d;
	butee_d = (IORD_16DIRECT(AVALON_F6_0_BASE, 16) & 0x0008) >> 3;
	return 	butee_d;
}



uint32_t read_f_butee_g(){
	uint32_t butee_g;
	butee_g = (IORD_16DIRECT(AVALON_F6_0_BASE, 16) & 0x0010) >> 4;
	return butee_g;
}

