#include <stdlib.h>
#include <stdint.h>
#include "ext_com.h"

extern int ghdl_main (int argc, char **argv);

int main(int argc, char **argv) {

  actor_t actor_1 = ext_com_new_actor("external actor", 10, 100);
  actor_t actor_2 = ext_com_new_actor("Full sentence name", 1000000, 2000000);

  queue_t *queue = malloc(sizeof(queue_t));
  queue->meta = 20;
  queue->data = 99;
  msg_t msg = new_msg(8, queue);
  put_msg(actor_2, msg);

  return ghdl_main(argc, argv);
}

