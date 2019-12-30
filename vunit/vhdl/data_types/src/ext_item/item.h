#ifndef ITEM_H
#define ITEM_H

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include "ghdl_types.h"
#include "types.h"
#include "codec.h"

typedef struct {
  type_t  type;
  uint8_t code[];
} item_t;

item_t* new_item(type_t type, uint32_t length);

char item_to_char(const item_t *item);

item_t* char_to_item(char character);

int32_t item_to_int(const item_t *item);

item_t* int_to_item(int32_t integer);

array_t item_to_string(const item_t *item);

item_t* string_to_item(array_t string);

#endif

