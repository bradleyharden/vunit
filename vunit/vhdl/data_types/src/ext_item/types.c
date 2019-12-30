#include <stdlib.h>
#include <stdio.h>
#include "types.h"

void type_check(type_t got, type_t expected) {
  if (got != expected) {
    //printf("Invalid type conversion. Got %s, expected %s.",
    //       type_name(got), type_name(expected));
    exit(1);
  }
}

