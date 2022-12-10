#ifndef FONCTION1_H
#define FONCTION1_H
#include <stdint.h>
#include "system.h"
#include "io.h"

void anemometre_set_config(uint8_t raz,  uint8_t continu, uint8_t mono);
uint32_t anemometre_get_data();
void girouette_set_config(uint8_t raz, uint8_t continu, uint8_t mono);
uint32_t girouette_get_data();

#endif /* FONCTION1_H */
