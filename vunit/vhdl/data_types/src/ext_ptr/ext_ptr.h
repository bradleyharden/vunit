#ifndef EXT_PTR_H
#define EXT_PTR_H

typedef struct ptr_t {
  int32_t ref;  // Index into the storage array. If < 0, ptr is null
} ptr_t;

#define NULL_PTR (ptr_t){.ref = -1}

ptr_t ptr_new(uint32_t length, const void *value, const char *name);

void ptr_reallocate(ptr_t ptr, uint32_t length, const void *value);

void ptr_deallocate(ptr_t *ptr);

ptr_t ptr_find(const char *name);

void* ptr_bare(ptr_t ptr);

uint32_t ptr_length(ptr_t ptr);

char* ptr_name(ptr_t ptr);

void ptr_resize(ptr_t ptr, uint32_t length, uint32_t drop, uint32_t rotate);

ptr_t ptr_copy(ptr_t ptr, const char *name);

#endif

