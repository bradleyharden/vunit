#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "ext_ptr.h"

extern int ghdl_main (int argc, char **argv);

void run_Write_sequence_to_C(void) {
  ptr_t seq = ptr_find("Write sequence to C");
  if (!ptr_is_null(seq)) {
    uint8_t *bare = ptr_bare(seq);
    for (int i = 0; i < ptr_size(seq); i++) {
      if (bare[i] != i) {
        printf("Equality check failed for ext_ptr value. "
               "Got %d, expected %d.\n", bare[i], i);
        exit(1);
      }
    }
  }
}

int main(int argc, char **argv) {

  ptr_t seq = ptr_new(256, NULL, "Read sequence from C");
  uint8_t *ptr = ptr_bare(seq);
  for (int i = 0; i < ptr_size(seq); i++) {
    ptr[i] = i;
  }

  atexit(run_Write_sequence_to_C);

  return ghdl_main(argc, argv);
}

