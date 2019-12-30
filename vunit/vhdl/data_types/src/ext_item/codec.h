#ifndef CODEC_H
#define CODEC_H

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include "ghdl_types.h"
#include "types.h"

typedef union {
  bool     boolean;
  uint8_t  bit;
  char     character;
  uint32_t integer;
  double   real;
  uint64_t time;
  uint8_t  severity_level;
  uint8_t  file_open_kind;
  uint8_t  file_open_status;
  uint8_t  std_ulogic;
  uint8_t  type;
  uint8_t  byte;
} fixed_t;

uint32_t code_length(type_t type, uint32_t length);

uint32_t encode_fixed(const fixed_t *fixed, const type_t type, uint8_t *code);

uint32_t decode_fixed(const uint8_t *code, const type_t type, fixed_t *fixed);

uint32_t encode_range(const range_t *range, uint8_t *code);

uint32_t decode_range(const uint8_t *code, range_t *range);

uint32_t encode_array(const array_t *array, const type_t type, uint8_t *code);

uint32_t decode_array(const uint8_t *code, const type_t type, array_t *array);

#endif

