#include "item.h"

item_t* new_item(type_t type, uint32_t length) {
  item_t *item = malloc(sizeof(item) + length);
  item->type = type;
  return item;
}

fixed_t item_to_fixed(const item_t *item, type_t type) {
  type_check(item->type, type);
  const uint8_t *code = item->code;
  fixed_t fixed;
  decode_fixed(code, type, &fixed);
  return fixed;
}

item_t* fixed_to_item(fixed_t fixed, type_t type) {
  uint32_t length = code_length(type, 1);
  item_t *item = new_item(type, length);
  uint8_t *code = item->code;
  encode_fixed(&fixed, type, code);
  return item;
}

array_t item_to_array(const item_t *item, type_t type) {
  type_check(item->type, type);
  const uint8_t *code = item->code;
  array_t array;
  decode_array(code, type, &array);
  return array;
}

item_t* array_to_item(array_t array, type_t type) {
  uint32_t length = code_length(VUNIT_RANGE, 1) +
                    code_length(type, array.range->len);
  item_t *item = new_item(type, length);
  uint8_t *code = item->code;
  encode_array(&array, type, code);
  return item;
}

char item_to_char(const item_t *item) {
  fixed_t fixed = item_to_fixed(item, VHDL_CHARACTER);
  return fixed.character;
}

item_t* char_to_item(char character) {
  fixed_t fixed = {.character = character};
  return fixed_to_item(fixed, VHDL_CHARACTER);
}

int32_t item_to_int(const item_t *item) {
  fixed_t fixed = item_to_fixed(item, VHDL_INTEGER);
  return fixed.integer;
}

item_t* int_to_item(int32_t integer) {
  fixed_t fixed = {.integer = integer};
  return fixed_to_item(fixed, VHDL_INTEGER);
}

array_t item_to_string(const item_t *item) {
  return item_to_array(item, VHDL_STRING);
}

item_t* string_to_item(array_t string) {
  return array_to_item(string, VHDL_STRING);
}

