#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "ext_ptr.h"

#define DEFAULT_STORAGE_LENGTH 256

// Pointer storage data structure
typedef struct {
  char     *name;  // Unique name for pointer
  uint32_t  size;  // Size of buffer, in bytes
  void     *bare;  // Bare pointer
} storage_item_t;

#define NULL_STORAGE_ITEM (storage_item_t){.name=NULL, .size=0, .bare=NULL}

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
  if (ptr.ref < 0 || ptr.ref >= storage.index) {
    printf("Attempted to access invalid or null ext_ptr (ref = %d)\n", ptr.ref);
    exit(1);
  }
  if (storage.items[ptr.ref].bare == NULL) {
    printf("Attempted to access unallocated ext_ptr with ref = %d "
           " and name = %s.\n", ptr.ref, ptr_name(ptr));
    exit(1);
  }
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

bool ptr_is_null(ptr_t ptr) {
  return ptr.ref < 0;
}

ptr_t ptr_new(uint32_t size, const void *data, const char *name) {
  if (size == 0) {
    printf("ptr_new: size must be > 0\n");
    exit(1);
  }
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
  item->bare = malloc(size);
  assert(item->bare != NULL);
  // Copy the data, if it exists. Otherwise, set to zeros
  if (data == NULL)
    memset(item->bare, 0, item->size);
  else
    memcpy(item->bare, data, item->size);
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

void ptr_reallocate(ptr_t ptr, uint32_t size, const void *data) {
  check_valid(ptr);
  storage_item_t *item = &storage.items[ptr.ref];
  item->size = size;
  item->bare = realloc(item->bare, size);
  assert(item->bare != NULL);
  // Copy the data, if it exists. Otherwise, set to zeros
  if (data == NULL)
    memset(item->bare, 0, item->size);
  else
    memcpy(item->bare, data, item->size);
}

void ptr_deallocate(ptr_t *ptr) {
  if (ptr->ref >= 0) {
    check_valid(*ptr);
    storage_item_t *item = &storage.items[ptr->ref];
    // Delete pointer and free memory
    free(item->name);
    free(item->bare);
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

void* ptr_bare(ptr_t ptr) {
  check_valid(ptr);
  return storage.items[ptr.ref].bare;
}

void ptr_resize(ptr_t ptr, uint32_t new_size) {
  check_valid(ptr);
  if (new_size == 0) {
    printf("ptr_resize: new_size must be > 0\n");
    exit(1);
  }
  storage_item_t *old = &storage.items[ptr.ref];
  uint32_t min_size = old->size < new_size ? old->size : new_size;
  void *new_bare = malloc(new_size);
  memcpy(new_bare, old->bare, min_size);
  free(old->bare);
  old->bare = new_bare;
  old->size = new_size;
}

void ptr_resize_char(ptr_t ptr, uint32_t new_length, char value,
                     uint32_t drop, uint32_t rotate) {
  check_valid(ptr);
  if (new_length == 0) {
    printf("ptr_resize_char: new_length must be > 0\n");
    exit(1);
  }
  if (drop > 0 && rotate > 0) {
    printf("ptr_resize_char: cannot use drop and rotate simulataneously\n");
    exit(1);
  }
  storage_item_t *old = &storage.items[ptr.ref];
  uint8_t *old_bare = old->bare;
  uint8_t *new_bare = calloc(new_length, 1);
  uint32_t old_length = old->size;
  uint32_t min_length = old_length - drop;
  if (new_length < min_length)
    min_length = new_length;
  for (int i = 0; i < min_length; i++) {
    uint32_t old_index = (drop + rotate + i) % old_length;
    uint32_t new_index = i;
    new_bare[new_index] = old_bare[old_index];
  }
  for (int i = min_length; i < new_length; i++) {
    new_bare[i] = value;
  }
  free(old->bare);
  old->bare = new_bare;
  old->size = new_length;
}

void ptr_resize_int(ptr_t ptr, uint32_t new_length, int32_t value,
                    uint32_t drop, uint32_t rotate) {
  check_valid(ptr);
  if (new_length == 0) {
    printf("ptr_resize_int: new_length must be > 0\n");
    exit(1);
  }
  if (drop > 0 && rotate > 0) {
    printf("ptr_resize_int: cannot use drop and rotate simulataneously\n");
    exit(1);
  }
  storage_item_t *old = &storage.items[ptr.ref];
  int32_t *old_bare = old->bare;
  int32_t *new_bare = calloc(new_length, 4);
  uint32_t old_length = old->size / 4;
  uint32_t min_length = old_length - drop;
  if (new_length < min_length)
    min_length = new_length;
  for (int i = 0; i < min_length; i++) {
    uint32_t old_index = (drop + rotate + i) % old_length;
    uint32_t new_index = i;
    new_bare[new_index] = old_bare[old_index];
  }
  for (int i = min_length; i < new_length; i++) {
    new_bare[i] = value;
  }
  free(old->bare);
  old->bare = new_bare;
  old->size = new_length * 4;
}

ptr_t ptr_copy(ptr_t ptr, const char *name) {
  if (ptr.ref < 0) {
    return NULL_PTR;
  }
  else {
    storage_item_t *item = &storage.items[ptr.ref];
    return ptr_new(item->size, item->bare, name);
  }
}


//-----------------------------------------------------------------------------
// VHPIDIRECT functions
//-----------------------------------------------------------------------------
int32_t vhpi_ptr_new(uint32_t size, const array_t *data, const array_t *name) {
  char *c_name = ghdl_array_to_string(*name);
  ptr_t ptr = ptr_new(size, data->value, c_name);
  return ptr.ref;
}

void vhpi_ptr_reallocate(int32_t ref, uint32_t size, const array_t *data) {
  ptr_t ptr = {ref};
  ptr_reallocate(ptr, size, data->value);
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

void vhpi_ptr_to_string(array_t *array, int32_t ref) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  storage_item_t *item = &storage.items[ref];
  range_t *range = malloc(sizeof(range_t));
  assert(range != NULL);
  range->left = 1;
  range->right = item->size;
  range->dir = 0;
  range->len = item->size;
  array->value = item->bare;
  array->range = range;
}

void vhpi_ptr_to_int_vec(array_t *array, int32_t ref) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  storage_item_t *item = &storage.items[ref];
  uint32_t length = item->size / 4;
  range_t *range = malloc(sizeof(range_t));
  assert(range != NULL);
  range->left = 0;
  range->right = length - 1;
  range->dir = 0;
  range->len = length;
  array->value = item->bare;
  array->range = range;
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
  uint8_t *array = storage.items[ref].bare;
  return array[index];
}

void vhpi_ptr_set_char(int32_t ref, uint32_t index, uint8_t value) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  uint8_t *array = storage.items[ref].bare;
  array[index] = value;
}

int32_t vhpi_ptr_get_int(int32_t ref, uint32_t index) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  int32_t *array = (int32_t *) storage.items[ref].bare;
  return array[index];
}

void vhpi_ptr_set_int(int32_t ref, uint32_t index, int32_t value) {
  ptr_t ptr = {ref};
  check_valid(ptr);
  int32_t *array = storage.items[ref].bare;
  array[index] = value;
}

