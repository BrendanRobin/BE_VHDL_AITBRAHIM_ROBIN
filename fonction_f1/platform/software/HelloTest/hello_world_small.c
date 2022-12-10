#include "io.h"
#include "sys/alt_stdio.h"
#include "system.h"
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include "inc/fonction1.h"


int main()
{ 
	uint32_t direction, Vitesse;
	alt_putstr("Hello from Nios II!\n");

	girouette_set_config(0,1,0);
	anemometre_set_config(0,1,0);



	/* Event loop never exits. */
	while (1){

			Vitesse = anemometre_get_data();
			direction = girouette_get_data();

			printf("vitesse du vent  = %u\n", Vitesse);
			printf("direction du  vent   = %u\n", direction);


			usleep(1000000);
		}

	return 0;
}
