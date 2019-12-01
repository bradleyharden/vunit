#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include "ext_com.h"

typedef struct envelope_t {
  msg_t              msg;
  struct envelope_t *next;
} envelope_t;

typedef struct mailbox_t {
  uint32_t    num_msgs;
  uint32_t    size;
  envelope_t *first;
  envelope_t *last;
} mailbox_t;

typedef struct line_t {
  uint32_t left;
  uint32_t right;
  uint32_t descending;
  uint32_t length;
  char     string[];
} line_t;

typedef struct actor_item_t {
  actor_t    actor;
  line_t    *name;
  mailbox_t *inbox;
  mailbox_t *outbox;
} actor_item_t;

typedef struct actor_storage_t {
  actor_item_t **actors;
  uint32_t       length;
} actor_storage_t;

#define NULL_ACTOR_STORAGE (actor_storage_t){.actors = NULL, .length = 0}

actor_storage_t actor_storage = NULL_ACTOR_STORAGE;

msg_t new_msg(uint32_t id, queue_t *data) {
  msg_t *msg = malloc(sizeof(msg_t));
  msg->id = id;
  msg->data = *data;
  *data = NULL_QUEUE;
  return *msg;
}


mailbox_t* ext_com_create_mailbox(uint32_t size) {
  mailbox_t *mailbox = malloc(sizeof(mailbox_t));
  mailbox->num_msgs = 0;
  mailbox->size = size;
  mailbox->first = NULL;
  mailbox->last = NULL;
  return mailbox;
}


void put_msg(actor_t actor, msg_t msg) {
  actor_item_t *actor_item = actor_storage.actors[actor.id - 1];
  mailbox_t *mailbox = actor_item->inbox;
  envelope_t *envelope = malloc(sizeof(envelope_t));
  envelope->msg = msg;
  envelope->next = NULL;
  if (mailbox->last == NULL)
    mailbox->first = envelope;
  else
    mailbox->last->next = envelope;
  mailbox->last = envelope;
  mailbox->num_msgs = mailbox->num_msgs + 1;
}


line_t* new_line(char *string) {
  uint32_t length = strlen(string);
  line_t *line = malloc(sizeof(line_t) + length * sizeof(char));
  line->left = 1;
  line->right = length;
  line->descending = 0;
  line->length = length;
  memcpy(line->string, string, sizeof(char) * length);
  return line;
}


actor_t ext_com_new_actor(char *name,
                          uint32_t inbox_size,
                          uint32_t outbox_size) {
  actor_item_t **old_actors = actor_storage.actors;
  actor_item_t **new_actors = calloc(actor_storage.length + 1,
                                     sizeof(actor_item_t*));
  assert(new_actors != NULL);
  if (old_actors != NULL) {
    for (int i = 0; i < actor_storage.length; i++) {
      new_actors[i] = old_actors[i];
    }
  }
  actor_item_t *item = malloc(sizeof(actor_item_t) + 
                              sizeof(char) * strlen(name));
  item->actor = (actor_t){.id = actor_storage.length + 1};
  item->name = new_line(name);
  item->inbox = ext_com_create_mailbox(inbox_size);
  item->outbox = ext_com_create_mailbox(outbox_size);
  new_actors[actor_storage.length] = item;
  actor_storage.actors = new_actors;
  actor_storage.length = actor_storage.length + 1;
  return item->actor;
}

uint32_t ext_com_num_actors(void) {
  return actor_storage.length;
}

actor_item_t* ext_com_get_actor_item(uint32_t index) {
  return actor_storage.actors[index];
}


