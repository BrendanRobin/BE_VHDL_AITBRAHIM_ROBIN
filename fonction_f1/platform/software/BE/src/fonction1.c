#include "../inc/fonction1.h"


void anemometre_set_config(uint8_t raz,  uint8_t continu, uint8_t mono){
	uint8_t config = 0x00;
	if(raz == 1){
		config = config | 0x01;
	}
	if(continu == 1){
		config = config | 0x02;
	}
	if(mono == 1){
		config = config | 0x04;
	}

	IOWR_8DIRECT(AVALON_F1_0_BASE, 4, config);
}

uint32_t anemometre_get_data(){
	uint32_t data;
	data = IORD_16DIRECT(AVALON_F1_0_BASE, 6) & 0x3FF;
	return data;
}

void girouette_set_config(uint8_t raz, uint8_t continu, uint8_t mono){
	uint8_t config = 0x00;
	if(raz == 1){
		config = config | 0x01;
	}
	if(continu == 1){
		config = config | 0x02;
	}
	if(mono == 1){
		config = config | 0x04;
	}

	IOWR_8DIRECT(AVALON_F1_0_BASE, 0, config);
}

uint32_t girouette_get_data(){
	uint32_t data;
	data = IORD_16DIRECT(AVALON_F1_0_BASE, 2) & 0x3FF;
	return data;
}
