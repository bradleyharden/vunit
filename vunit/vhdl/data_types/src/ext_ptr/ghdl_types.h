#ifndef GHDL_TYPES_H
#define GHDL_TYPES_H

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

typedef struct {
  uint32_t left;
  uint32_t right;
  uint32_t dir;
  uint32_t len;
} range_t;

typedef struct {
  void    *array;
  range_t *range;
} array_t;

typedef struct {
  range_t range;
  uint8_t array[];
} access_t;

array_t ghdl_string_to_array(char *string) {
  range_t *range = malloc(sizeof(range_t));
  assert(range != NULL);
  uint32_t length = strlen(string);
  range->left = 1;
  range->right = length;
  range->dir = 0;
  range->len = length;
  // Don't bother copying the string, because GHDL will do that anyway
  return (array_t){.array=string, .range=range};
}

char* ghdl_array_to_string(array_t array) {
  // Add a null character, because GHDL strings are not null-terminated
  char *string = malloc(array.range->len + 1);
  strncpy(string, array.array, array.range->len);
  string[array.range->len] = '\0';
  return string;
}

access_t* ghdl_new_access(uint32_t length, size_t bytes) {
  access_t *access = malloc(sizeof(access_t) + length * bytes);
  assert(access != NULL);
  access->range.left = 0;
  access->range.right = length - 1;
  access->range.dir = 0;
  access->range.len = length;
  return access;
}

access_t* ghdl_string_to_line(char *string) {
  uint32_t length = strlen(string);
  access_t *line = ghdl_new_access(length, 1);
  // New access objects default to numbering from 0,
  // but VHDL strings must be numbered from 1
  line->range.left++;
  line->range.right++;
  // Don't copy the null termination
  strncpy(line->array, string, length);
  return line;
}

char* ghdl_line_to_string(access_t *line) {
  // Add a null character, because GHDL strings are not null-terminated
  char *string = malloc(line->range.len + 1);
  strncpy(string, line->array, line->range.len);
  string[line->range.len] = '\0';
}

#endif

