#include <stdio.h>
#include "codec.h"
#include "item.h"

int main(void) {

  // Test character
  char character = 'A';
  item_t *item = char_to_item(character);
  printf("char item: %02x %02x\n", item->type, item->code[0]);
  printf("char: %c\n", item_to_char(item));

  // Test string
  char *string = "Hello World!";
  array_t array = ghdl_string_to_array(string);
  item = string_to_item(array);
  uint32_t code_len = code_length(VUNIT_RANGE, 1) +
                      code_length(VHDL_STRING, strlen(string));
  printf("string item: %02x ", item->type);
  for (int i = 0; i < code_len; i++) {
    printf("%02x ", item->code[i]);
  }
  printf("\n");
  array = item_to_string(item);
  printf("string: %.*s\n", array.range->len, (char *) array.value);

  return 0;
}
