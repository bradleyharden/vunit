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

char* ptr_name(ptr_t ptr);

uint32_t ptr_size(ptr_t ptr);

void* ptr_bare(ptr_t ptr);

void ptr_resize(ptr_t ptr, uint32_t new_size);

void ptr_resize_char(ptr_t ptr, uint32_t new_length, char value,
                     uint32_t drop, uint32_t rotate);

void ptr_resize_int(ptr_t ptr, uint32_t new_length, int32_t value,
                    uint32_t drop, uint32_t rotate);

ptr_t ptr_copy(ptr_t ptr, const char *name);

#endif

