#ifndef LINE_H
#define LINE_H

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

typedef struct line_t {
  uint32_t left;
  uint32_t right;
  uint32_t descending;
  uint32_t length;
  char     string[];
} line_t;

line_t* new_line(char *string) {
  uint32_t length = strlen(string);
  line_t *line = malloc(sizeof(line_t) + sizeof(char) * length);
  line->left = 1;
  line->right = length;
  line->descending = 0;
  line->length = length;
  strncpy(line->string, string, length);
  return line;
}

#endif

