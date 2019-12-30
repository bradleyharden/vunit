#include <string.h>
#include <assert.h>
#include "ghdl_types.h"


array_t ghdl_string_to_array(const char *string) {
  range_t *range = malloc(sizeof(range_t));
  assert(range != NULL);
  uint32_t length = strlen(string);
  range->left = 1;
  range->right = length;
  range->dir = 0;
  range->len = length;
  char *value = malloc(length);
  assert(value != NULL);
  strncpy(value, string, length);
  return (array_t){.value=value, .range=range};
}

char* ghdl_array_to_string(const array_t array) {
  // Add a null character, because GHDL strings are not null-terminated
  char *string = malloc(array.range->len + 1);
  strncpy(string, array.value, array.range->len);
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

access_t* ghdl_string_to_line(const char *string) {
  uint32_t length = strlen(string);
  access_t *line = ghdl_new_access(length, 1);
  // New access objects default to numbering from 0,
  // but VHDL strings must be numbered from 1
  line->range.left++;
  line->range.right++;
  // Don't copy the null termination
  strncpy(line->value, string, length);
  return line;
}

char* ghdl_line_to_string(const access_t *line) {
  // Add a null character, because GHDL strings are not null-terminated
  char *string = malloc(line->range.len + 1);
  strncpy(string, line->value, line->range.len);
  string[line->range.len] = '\0';
}

