#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include "ghdl_types.h"
#include "ext_ptr.h"

#define DEFAULT_STORAGE_LENGTH 256

// Pointer storage data structure
typedef struct {
  char     *name;   // Unique name for pointer
  uint32_t  size;   // Size of buffer, in bytes
  access_t *access; // GHDL access type
} storage_item_t;

#define NULL_STORAGE_ITEM (storage_item_t){.name=NULL, .size=0, .access=NULL}

// Pointer storage container
typedef struct {
  storage_item_t *items;   // Array of pointer structs
  uint32_t        length;  // Length of array
  uint32_t        index;   // Next unused index in array
} storage_t;

#define NULL_STORAGE (storage_t){.items=NULL, .length=0, .index=0}

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
  assert(0 <= ptr.ref && ptr.ref < storage.index);
  assert(storage.items[ptr.ref].access != NULL);
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

ptr_t ptr_new(uint32_t size, const void *value, const char *name) {
  assert(size > 0);
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
  item->size = size;
  item->access = ghdl_new_access(size, 1);
  assert(item->access != NULL);
  // Copy the value, if it exists. Otherwise, set to zeros
  if (value == NULL)
    memset(item->access->array, 0, item->size);
  else
    memcpy(item->access->array, value, item->size);
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

void ptr_reallocate(ptr_t ptr, uint32_t size, const void *value) {
  check_valid(ptr);
  storage_item_t *item = &storage.items[ptr.ref];
  free(item->access);
  item->size = size;
  item->access = ghdl_new_access(size, 1);
  assert(item->access != NULL);
  // Copy the value, if it exists. Otherwise, set to zeros
  if (value == NULL)
    memset(item->access->array, 0, item->size);
  else
    memcpy(item->access->array, value, item->size);
}

void ptr_deallocate(ptr_t *ptr) {
  if (ptr->ref >= 0) {
    check_valid(*ptr);
    storage_item_t *item = &storage.items[ptr->ref];
    // Delete pointer and free memory
    free(item->name);
    free(item->access);
    *item = NULL_STORAGE_ITEM;
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

char* ptr_name(ptr_t ptr) {
  check_valid(ptr);
  return storage.items[ptr.ref].name;
}

uint32_t ptr_size(ptr_t ptr) {
  check_valid(ptr);
  return storage.items[ptr.ref].size;
}

void* ptr_array(ptr_t ptr) {
  check_valid(ptr);
  return storage.items[ptr.ref].access->array;
}

void ptr_resize(ptr_t ptr, uint32_t new_size) {
  check_valid(ptr);
  assert(new_size > 0);
  storage_item_t *old = &storage.items[ptr.ref];
  uint32_t min_size = old->size < new_size ? old->size : new_size;
  access_t *new_access = ghdl_new_access(new_size, 1);
  memcpy(new_access->array, old->access->array, min_size);
  free(old->access);
  old->access = new_access;
  old->size = new_size;
}

void ptr_resize_char(ptr_t ptr, uint32_t new_length, char value,
                     uint32_t drop, uint32_t rotate) {
  check_valid(ptr);
  assert(new_length > 0);
  assert(drop == 0 || rotate == 0);
  storage_item_t *old = &storage.items[ptr.ref];
  access_t *new_access = ghdl_new_access(new_length, 1);
  uint32_t old_length = old->size;
  uint32_t min_length = old_length - drop;
  if (new_length < min_length)
    min_length = new_length;
  for (int i = 0; i < min_length; i++) {
    uint32_t old_index = (drop + rotate + i) % old_length;
    uint32_t new_index = i;
    new_access->array[new_index] = old->access->array[old_index];
  }
  for (int i = min_length; i < new_length; i++) {
    new_access->array[i] = value;
  }
  free(old->access);
  old->access = new_access;
  old->size = new_length;
}

void ptr_resize_int(ptr_t ptr, uint32_t new_length, int32_t value,
                    uint32_t drop, uint32_t rotate) {
  check_valid(ptr);
  assert(new_length > 0);
  assert(drop == 0 || rotate == 0);
  storage_item_t *old = &storage.items[ptr.ref];
  access_t *new_access = ghdl_new_access(new_length, 4);
  uint32_t old_length = old->size / 4;
  uint32_t min_length = old_length - drop;
  if (new_length < min_length)
    min_length = new_length;
  int32_t *old_array = (int32_t *) old->access->array;
  int32_t *new_array = (int32_t *) new_access->array;
  for (int i = 0; i < min_length; i++) {
    uint32_t old_index = (drop + rotate + i) % old_length;
    uint32_t new_index = i;
    new_array[new_index] = old_array[old_index];
  }
  for (int i = min_length; i < new_length; i++) {
    new_array[i] = value;
  }
  free(old->access);
  old->access = new_access;
  old->size = new_length * 4;
}

ptr_t ptr_copy(ptr_t ptr, const char *name) {
  if (ptr.ref < 0) {
    return NULL_PTR;
  }
  else {
    storage_item_t *item = &storage.items[ptr.ref];
    return ptr_new(item->size, item->access->array, name);
  }
}


//-----------------------------------------------------------------------------
// VHPIDIRECT functions
//-----------------------------------------------------------------------------
int32_t vhpi_ptr_new(uint32_t size, const array_t *value, const array_t *name) {
  char *c_name = ghdl_array_to_string(*name);
  ptr_t ptr = ptr_new(size, value->array, c_name);
  return ptr.ref;
}

void vhpi_ptr_reallocate(int32_t ref, uint32_t size, const array_t *value) {
  ptr_t ptr = {ref};
  ptr_reallocate(ptr, size, value->array);
}

void vhpi_ptr_deallocate(int32_t ref) {
  ptr_t ptr = {ref};
  ptr_deallocate(&ptr);
}

int32_t vhpi_ptr_find(const array_t *name) {
  char *c_name = ghdl_array_to_string(*name);
  ptr_t ptr = ptr_find(c_name);
  return ptr.ref;
}

void vhpi_ptr_name(array_t *name, int32_t ref) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  *name = ghdl_string_to_array(storage.items[ref].name);
}

uint32_t vhpi_ptr_size(int32_t ref) {
  ptr_t ptr = {ref};
  return ptr_size(ptr);
}

access_t* vhpi_ptr_view_str(int32_t ref) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  storage_item_t *item = &storage.items[ref];
  uint32_t length = item->size;
  range_t *range = &item->access->range;
  range->left = 1;
  range->right = length;
  range->dir = 0;
  range->len = length;
  return item->access;
}

access_t* vhpi_ptr_view_int(int32_t ref) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  storage_item_t *item = &storage.items[ref];
  uint32_t length = item->size / 4;
  range_t *range = &item->access->range;
  range->left = 0;
  range->right = length - 1;
  range->dir = 0;
  range->len = length;
  return item->access;
}

void vhpi_ptr_resize(int32_t ref, uint32_t size) {
  ptr_t ptr = {ref};
  ptr_resize(ptr, size);
}

void vhpi_ptr_resize_char(int32_t ref, uint32_t new_length, char value,
                          uint32_t drop, uint32_t rotate) {
  ptr_t ptr = {ref};
  ptr_resize_char(ptr, new_length, value, drop, rotate);
}

void vhpi_ptr_resize_int(int32_t ref, uint32_t new_length, int32_t value,
                         uint32_t drop, uint32_t rotate) {
  ptr_t ptr = {ref};
  ptr_resize_int(ptr, new_length, value, drop, rotate);
}

int32_t vhpi_ptr_copy(int32_t ref, const array_t *name) {
  ptr_t ptr = {ref};
  char *c_name = ghdl_array_to_string(*name);
  ptr = ptr_copy(ptr, c_name);
  return ptr.ref;
}

uint8_t vhpi_ptr_get_char(int32_t ref, uint32_t index) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  uint8_t *array = storage.items[ref].access->array;
  return array[index];
}

void vhpi_ptr_set_char(int32_t ref, uint32_t index, uint8_t value) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  uint8_t *array = storage.items[ref].access->array;
  array[index] = value;
}

int32_t vhpi_ptr_get_int(int32_t ref, uint32_t index) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  int32_t *array = (int32_t *) storage.items[ref].access->array;
  return array[index];
}

void vhpi_ptr_set_int(int32_t ref, uint32_t index, int32_t value) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  int32_t *array = (int32_t *) storage.items[ref].access->array;
  array[index] = value;
}

