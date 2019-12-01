#ifndef EXT_COM_H
#define EXT_COM_H

typedef struct actor_t {
  int32_t id;
} actor_t;

typedef struct queue_t {
  int32_t meta;
  int32_t data;
} queue_t;

#define NULL_QUEUE (queue_t){.meta = -1, .data = -1}

typedef struct msg_t {
  uint32_t id;
  uint32_t msg_type;
  uint32_t status;
  actor_t  sender;
  actor_t  receiver;
  uint32_t req_id;
  queue_t  data;
} msg_t;

actor_t ext_com_new_actor(char *name,
                          uint32_t inbox_size,
                          uint32_t outbox_size);

msg_t new_msg(uint32_t id, queue_t *data);

void put_msg(actor_t actor, msg_t msg);

#endif

