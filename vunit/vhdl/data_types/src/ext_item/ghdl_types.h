#ifndef GHDL_TYPES_H
#define GHDL_TYPES_H

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

typedef struct {
  uint32_t left;
  uint32_t right;
  uint32_t dir;
  uint32_t len;
} range_t;

typedef struct {
  void    *value;
  range_t *range;
} array_t;

typedef struct {
  range_t range;
  uint8_t value[];
} access_t;

array_t ghdl_string_to_array(char *string);

char* ghdl_array_to_string(array_t array);

access_t* ghdl_new_access(uint32_t length, size_t bytes);

access_t* ghdl_string_to_line(char *string);

char* ghdl_line_to_string(access_t *line);

#endif

