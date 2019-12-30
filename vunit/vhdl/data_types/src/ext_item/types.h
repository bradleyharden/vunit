#ifndef TYPES_H
#define TYPES_H

#include <stdlib.h>
#include <stdint.h>
#include "ghdl_types.h"

typedef uint8_t type_t;

#define NULL_TYPE                   0
#define VHDL_NULL                   1
#define VHDL_BOOLEAN                2
#define VHDL_BOOLEAN_VECTOR         3
#define VHDL_BIT                    4
#define VHDL_BIT_VECTOR             5
#define VHDL_CHARACTER              6
#define VHDL_STRING                 7
#define VHDL_INTEGER                8
#define VHDL_INTEGER_VECTOR         9
#define VHDL_REAL                  10
#define VHDL_REAL_VECTOR           11
#define VHDL_TIME                  12
#define VHDL_TIME_VECTOR           13
#define VHDL_SEVERITY_LEVEL        14
#define VHDL_FILE_OPEN_KIND        15
#define VHDL_FILE_OPEN_STATUS      16
#define IEEE_COMPLEX               17
#define IEEE_COMPLEX_POLAR         18
#define IEEE_NUMERIC_BIT_UNSIGNED  19
#define IEEE_NUMERIC_BIT_SIGNED    20
#define IEEE_STD_ULOGIC            21
#define IEEE_STD_ULOGIC_VECTOR     22
#define IEEE_NUMERIC_STD_UNSIGNED  23
#define IEEE_NUMERIC_STD_SIGNED    24
#define IEEE_UFIXED                25
#define IEEE_SFIXED                26
#define IEEE_FLOAT                 27
#define VUNIT_TYPE                 28
#define VUNIT_RANGE                29
#define VUNIT_BYTE                 30
#define VUNIT_INTEGER_VECTOR_PTR   31
#define VUNIT_STRING_PTR           32

void type_check(type_t got, type_t expected);

#endif

