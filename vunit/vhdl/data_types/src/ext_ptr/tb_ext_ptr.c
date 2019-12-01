#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "ext_ptr.h"

extern int ghdl_main (int argc, char **argv);

int main(int argc, char **argv) {

  ptr_t char_seq = ptr_new(256, NULL, "Read sequence from C");
  uint8_t *ptr = ptr_bare(char_seq);
  for (int i = 0; i < ptr_length(char_seq); i++) {
    ptr[i] = i;
  }

  return ghdl_main(argc, argv);
}

