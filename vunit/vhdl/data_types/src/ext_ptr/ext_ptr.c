#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include "line.h"
#include "ext_ptr.h"

#define DEFAULT_STORAGE_LENGTH 256

// Pointer storage data structure
typedef struct {
  void     *bare;  // Bare pointer
  uint32_t  len;   // Pointer length, in bytes
  char     *name;  // Unique name for pointer
} storage_item_t;

#define NULL_STORAGE_ITEM (storage_item_t){.bare = NULL, .len = 0, .name = NULL}

// Pointer storage container
typedef struct {
  storage_item_t *items;   // Array of pointer structs
  uint32_t        length;  // Length of array
  uint32_t        index;   // Next unused index in array
} storage_t;

#define NULL_STORAGE (storage_t){.items = NULL, .length = 0, .index = 0}

// Global pointer storage variable
storage_t storage = NULL_STORAGE;

// Initialize the global pointer storage variable
storage_t init_storage(void) {
  storage_t s;
  s.length = DEFAULT_STORAGE_LENGTH;
  s.index = 0;
  s.items = calloc(s.length, sizeof(storage_item_t));
  assert(s.items != NULL);
  // Initialize storage items
  for (int i = 0; i < s.length; i++) {
    s.items[i] = NULL_STORAGE_ITEM;
  }
  return s;
}

// Linked list struct used to build stack of unused storage indices
typedef struct stack_item_t {
  uint32_t ref;
  struct stack_item_t *next;
} stack_item_t;

// Stack of unused indices
stack_item_t *stack = NULL;

// Verify that a given pointer is valid
static inline void check_valid(ptr_t ptr) {
  //assert(0 <= ptr.ref && ptr.ref < storage.index);
  //assert(storage.items[ptr.ref].bare != NULL);
}

// Reallocate storage array
void reallocate_storage(uint32_t new_length) {
  // Check the new length
  assert(new_length >= storage.length);
  // Allocate the storage items
  size_t new_size = sizeof(storage_item_t) * new_length;
  storage.items = realloc(storage.items, new_size);
  assert(storage.items != NULL);
  // Initialize the new storage items
  for(int i = storage.length; i < new_length; i++) {
    storage.items[i] = NULL_STORAGE_ITEM;
  }
  storage.length = new_length;
}

ptr_t ptr_new(uint32_t length, const void *value, const char *name) {
  // Find a free index in the storage array
  ptr_t ptr;
  if (stack == NULL) {
    if (storage.items == NULL) {
      storage = init_storage();
    }
    if (storage.index >= storage.length) {
      reallocate_storage(2 * storage.length);
    }
    ptr.ref = storage.index++;
  }
  else {
    stack_item_t *head = stack;
    stack = head->next;
    ptr.ref = head->ref;
    free(head);
  }
  // Get the storage element and allocate the pointer
  storage_item_t *item = &storage.items[ptr.ref];
  item->len = length;
  item->bare = malloc(length);
  assert(item->bare != NULL);
  // Copy the value, if it exists. Otherwise, set to zeros
  if (value == NULL)
    memset(item->bare, 0, length);
  else
    memcpy(item->bare, value, length);
  // If user did not give name, use hex address with "<+/->" prefix
  if (name == NULL || strlen(name) == 0) {
    item->name = malloc(14);
    assert(item->name != NULL);
    sprintf(item->name, "<+/->%08x", ptr.ref);
  }
  else {
    item->name = malloc(strlen(name) + 1);
    assert(item->name != NULL);
    strcpy(item->name, name);
  }
  return ptr;
}

void ptr_reallocate(ptr_t ptr, uint32_t length, const void *value) {
  check_valid(ptr);
  storage_item_t *item = &storage.items[ptr.ref];
  free(item->bare);
  item->len = length;
  item->bare = malloc(length);
  assert(item->bare != NULL);
  // Copy the value, if it exists. Otherwise, set to zeros
  if (value == NULL)
    memset(item->bare, 0, length);
  else
    memcpy(item->bare, value, length);
}

void ptr_deallocate(ptr_t *ptr) {
  if (ptr->ref >= 0) {
    check_valid(*ptr);
    // Delete pointer and free memory
    free(storage.items[ptr->ref].bare);
    free(storage.items[ptr->ref].name);
    storage.items[ptr->ref] = NULL_STORAGE_ITEM;
    // Add index to the stack of unused indices
    stack_item_t *head = malloc(sizeof(stack_item_t));
    assert(head != NULL);
    head->ref = ptr->ref;
    head->next = stack;
    stack = head;
  }
  *ptr = NULL_PTR;
}

ptr_t ptr_find(const char *name) {
  ptr_t ptr = NULL_PTR;
  storage_item_t *item;
  for (int i = 0; i < storage.index; i++) {
    item = &storage.items[i];
    if (item->name != NULL && strcmp(item->name, name) == 0) {
      ptr.ref = i;
      break;
    }
  }
  return ptr;
}

void* ptr_bare(ptr_t ptr) {
  check_valid(ptr);
  return storage.items[ptr.ref].bare;
}

uint32_t ptr_length(ptr_t ptr) {
  check_valid(ptr);
  return storage.items[ptr.ref].len;
}

char* ptr_name(ptr_t ptr) {
  check_valid(ptr);
  return storage.items[ptr.ref].name;
}

void ptr_resize(ptr_t ptr, uint32_t length, uint32_t drop, uint32_t rotate) {
  check_valid(ptr);
  assert(drop == 0 || rotate == 0);
  // Get existing storage item
  storage_item_t *old = &storage.items[ptr.ref];
  // Allocate new bare pointer
  uint8_t *new_bare = malloc(length);
  assert(new_bare != NULL);
  // Find the minimum length
  uint32_t min_length = old->len - drop;
  if (length < min_length) {
    min_length = length;
  }
  // Copy data
  uint8_t *old_bare = old->bare;
  uint32_t index;
  for (int i = 0; i < min_length; i++) {
    index = (drop + rotate + i) % old->len;
    new_bare[i] = old_bare[index];
  }
  // Set new values
  free(old->bare);
  old->bare = new_bare;
  old->len = length;
}

ptr_t ptr_copy(ptr_t ptr, const char *name) {
  if (ptr.ref < 0) {
    return NULL_PTR;
  }
  else {
    storage_item_t *item = &storage.items[ptr.ref];
    return ptr_new(item->len, item->bare, name);
  }
}


//-----------------------------------------------------------------------------
// VHPIDIRECT-speicific functions
//-----------------------------------------------------------------------------
int32_t ptr_new_vhpi(uint32_t length, const void **value, const char **name) {
  ptr_t ptr = ptr_new(length, *value, *name);
  return ptr.ref;
}

void ptr_reallocate_vhpi(int32_t ref, uint32_t length, const void **value) {
  ptr_t ptr = {ref};
  ptr_reallocate(ptr, length, *value);
}

void ptr_deallocate_vhpi(int32_t ref) {
  ptr_t ptr = {ref};
  ptr_deallocate(&ptr);
}

int32_t ptr_find_vhpi(const char **name) {
  ptr_t ptr = ptr_find(*name);
  return ptr.ref;
}

void** ptr_bare_vhpi(int32_t ref) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  return &storage.items[ref].bare;
}

uint32_t ptr_length_vhpi(int32_t ref) {
  ptr_t ptr = {ref};
  return ptr_length(ptr);
}

line_t* ptr_name_vhpi(int32_t ref) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  return new_line(storage.items[ref].name);
}

void ptr_resize_vhpi(int32_t ref, uint32_t length,
                     uint32_t drop, uint32_t rotate) {
  ptr_t ptr = {ref};
  ptr_resize(ptr, length, drop, rotate);
}

int32_t ptr_copy_vhpi(int32_t ref, const char **name) {
  ptr_t ptr = {ref};
  ptr = ptr_copy(ptr, *name);
  return ptr.ref;
}

uint8_t ptr_get_char_vhpi(int32_t ref, uint32_t index) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  uint8_t *bare = storage.items[ref].bare;
  return bare[index];
}

void ptr_set_char_vhpi(int32_t ref, uint32_t index, uint8_t value) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  uint8_t *bare = storage.items[ref].bare;
  bare[index] = value;
}

int32_t ptr_get_int_vhpi(int32_t ref, uint32_t index) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  int32_t *bare = storage.items[ref].bare;
  return bare[index];
}

void ptr_set_int_vhpi(int32_t ref, uint32_t index, int32_t value) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  int32_t *bare = storage.items[ref].bare;
  bare[index] = value;
}

