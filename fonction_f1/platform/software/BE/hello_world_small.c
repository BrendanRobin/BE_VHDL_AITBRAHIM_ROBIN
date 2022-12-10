#include "io.h"
#include "sys/alt_stdio.h"
#include "system.h"
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include "inc/fonction1.h"
#include "inc/fonction6.h"
#include "system.h"

int main()
{ 
	uint32_t direction, Vitesse, read_test, read_test1, read_test2;
	uint32_t clk_fpga = 50000000;
	uint32_t frequence = 25000;
	uint32_t duty = 50;
	uint32_t butee_d = 3500;
	uint32_t butee_g = 1500;
	uint32_t angle_barre, fin_butee_d, fin_butee_g;

	alt_putstr("Hello from Nios II!\n");

	girouette_set_config(0,1,0);
	anemometre_set_config(0,1,0);

	verin_freq(frequence, duty, clk_fpga);
	verin_butee(butee_d, butee_g);
	verin_config(1,1,0);


	/* Event loop never exits. */
	while (1){


			Vitesse = anemometre_get_data();
			direction = girouette_get_data();


			usleep(1000000);





			angle_barre =  read_angle();
			fin_butee_d = read_f_butee_d();
			fin_butee_g = read_f_butee_g();






			printf("fin de course d  %u\n", fin_butee_d);
			printf("fin de course g %u\n", fin_butee_g);
			printf("angle barre  %u\n", angle_barre);
			printf("vitesse du vent  = %u\n", Vitesse);
			printf("direction du  vent   = %u\n", direction);

			usleep(1000000);
		}

	return 0;
}
