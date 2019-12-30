#include <assert.h>
#include "codec.h"

uint8_t type_size(type_t type) {
  switch (type) {
    case NULL_TYPE:                 return 0;
    case VHDL_NULL:                 return 0;
    case VHDL_BOOLEAN:              return 1;
    case VHDL_BOOLEAN_VECTOR:       return type_size(VHDL_BOOLEAN);
    case VHDL_BIT:                  return 1;
    case VHDL_BIT_VECTOR:           return type_size(VHDL_BIT);
    case VHDL_CHARACTER:            return 8;
    case VHDL_STRING:               return type_size(VHDL_CHARACTER);
    case VHDL_INTEGER:              return 32;
    case VHDL_INTEGER_VECTOR:       return type_size(VHDL_INTEGER);
    case VHDL_REAL:                 return 64;
    case VHDL_REAL_VECTOR:          return type_size(VHDL_REAL);
    case VHDL_TIME:                 return 64;
    case VHDL_TIME_VECTOR:          return type_size(VHDL_TIME);
    case VHDL_SEVERITY_LEVEL:       return 8;
    case VHDL_FILE_OPEN_KIND:       return 8;
    case VHDL_FILE_OPEN_STATUS:     return 8;
    case IEEE_COMPLEX:              return 2 * type_size(VHDL_REAL);
    case IEEE_COMPLEX_POLAR:        return 2 * type_size(VHDL_REAL);
    case IEEE_NUMERIC_BIT_UNSIGNED: return type_size(VHDL_BIT);
    case IEEE_NUMERIC_BIT_SIGNED:   return type_size(VHDL_BIT);
    case IEEE_STD_ULOGIC:           return 4;
    case IEEE_STD_ULOGIC_VECTOR:    return type_size(IEEE_STD_ULOGIC);
    case IEEE_NUMERIC_STD_UNSIGNED: return type_size(IEEE_STD_ULOGIC);
    case IEEE_NUMERIC_STD_SIGNED:   return type_size(IEEE_STD_ULOGIC);
    case IEEE_UFIXED:               return type_size(IEEE_STD_ULOGIC);
    case IEEE_SFIXED:               return type_size(IEEE_STD_ULOGIC);
    case IEEE_FLOAT:                return type_size(IEEE_STD_ULOGIC);
    case VUNIT_TYPE:                return 8;
    case VUNIT_RANGE:               return 2 * type_size(VHDL_INTEGER) + type_size(VHDL_BOOLEAN);
    case VUNIT_BYTE:                return 8;
    case VUNIT_INTEGER_VECTOR_PTR:  return type_size(VHDL_INTEGER);
    case VUNIT_STRING_PTR:          return type_size(VHDL_INTEGER);
    default:                        return 0;
  }
}

uint32_t code_length(type_t type, uint32_t length) {
  uint8_t  size  = type_size(type);
  uint32_t bytes = size / 8;
  uint8_t  bits  = size % 8;
  return length * bytes + (length * bits + 7) / 8;
}

uint32_t encode_fixed(const fixed_t *fixed, const type_t type, uint8_t *code) {
  uint32_t length = code_length(type, 1);
  memcpy(code, fixed, length);
  return length;
}

uint32_t decode_fixed(const uint8_t *code, const type_t type, fixed_t *fixed) {
  uint32_t length = code_length(type, 1);
  memcpy(fixed, code, length);
  return length;
}

uint32_t encode_range(const range_t *range, uint8_t *code) {
  uint8_t int_len = code_length(VHDL_INTEGER, 1);
  memcpy(code, &range->left,  int_len);
  code += int_len;
  memcpy(code, &range->right, int_len);
  code += int_len;
  *code = range->dir ? 1 : 0;
  return code_length(VUNIT_RANGE, 1);
}

uint32_t decode_range(const uint8_t *code, range_t *range) {
  uint8_t int_len = code_length(VHDL_INTEGER, 1);
  memcpy(&range->left,  code, int_len);
  code += int_len;
  memcpy(&range->right, code, int_len);
  code += int_len;
  range->dir = *code ? 1 : 0;
  range->len = range->dir ? (range->left - range->right) :
                            (range->right - range->left);
  range->len++;
  return code_length(VUNIT_RANGE, 1);
}

uint32_t encode_array(const array_t *array, const type_t type, uint8_t *code) {
  code += encode_range(array->range, code);
  uint32_t length = code_length(type, array->range->len);
  memcpy(code, array->value, length);
  return code_length(VUNIT_RANGE, 1) + length;
}

uint32_t decode_array(const uint8_t *code, const type_t type, array_t *array) {
  range_t *range = malloc(sizeof(range_t));
  assert(range != NULL);
  code += decode_range(code, range);
  uint32_t length = code_length(type, range->len);
  uint8_t *value;
  switch (type) {
    case VHDL_BOOLEAN_VECTOR:
    case VHDL_BIT_VECTOR:
      if (length < 8) {
        value = malloc(8);
        memset(value, 0, 8);
      }
      else
        value = malloc(length);
    case VHDL_STRING:
      value = malloc(length + 1);
      value[length] = 0;
    default:
      value = malloc(length);
  }
  assert(value != NULL);
  memcpy(value, code, length);
  array->range = range;
  array->value = value;
  return code_length(VUNIT_RANGE, 1) + length;
}

