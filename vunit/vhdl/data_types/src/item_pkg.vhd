-- This file provides functionality to encode/decode standard types to/from string.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

library ieee;
use ieee.math_real.all;
use ieee.math_complex.all;
use ieee.numeric_bit.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.type_pkg.all;
use work.integer_vector_ptr_pkg.all;
use work.string_ptr_pkg.all;
use work.string_ptr_vector_ptr_pkg.all;
use work.codec_pkg.all;

package item_pkg is

  subtype item_t is string;

  function new_item (
    constant typ  : type_t;
    constant code : string)
    return item_t;

  constant null_item : item_t := new_item(null_type, "");

  function get_type (
    constant item : item_t)
    return type_t;

  function get_code (
    constant item : item_t)
    return string;

  impure function trim_type (
    constant item : item_t;
    constant typ  : type_t)
    return string;

  -----------------------------------------------------------------------------
  -- VHDL types
  -----------------------------------------------------------------------------
  impure function to_item (
    constant value : boolean)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return boolean;
  impure function to_item (
    constant value : bit)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return bit;
  impure function to_item (
    constant value : bit_vector)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return bit_vector;
  impure function to_item (
    constant value : character)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return character;
  impure function to_item (
    constant value : string)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return string;
  impure function to_item (
    constant value : integer)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return integer;
  impure function to_item (
    constant value : real)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return real;
  impure function to_item (
    constant value : time)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return time;
  impure function to_item (
    constant value : severity_level)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return severity_level;
  impure function to_item (
    constant value : file_open_status)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return file_open_status;
  impure function to_item (
    constant value : file_open_kind)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return file_open_kind;

  -----------------------------------------------------------------------------
  -- IEEE types
  -----------------------------------------------------------------------------
  impure function to_item (
    constant value : ieee.numeric_bit.unsigned)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return ieee.numeric_bit.unsigned;
  impure function to_item (
    constant value : ieee.numeric_bit.signed)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return ieee.numeric_bit.signed;
  impure function to_item (
    constant value : complex)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return complex;
  impure function to_item (
    constant value : complex_polar)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return complex_polar;
  impure function to_item (
    constant value : std_ulogic)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return std_ulogic;
  impure function to_item (
    constant value : std_ulogic_vector)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return std_ulogic_vector;
  impure function to_item (
    constant value : ieee.numeric_std.unsigned)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return ieee.numeric_std.unsigned;
  impure function to_item (
    constant value : ieee.numeric_std.signed)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return ieee.numeric_std.signed;

  -----------------------------------------------------------------------------
  -- VUnit types
  -----------------------------------------------------------------------------
  impure function to_item (
    constant value : type_t)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return type_t;
  impure function to_item (
    constant value : range_t)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return range_t;
  impure function byte_to_item (
    constant value : natural range 0 to 255)
    return item_t;
  impure function to_byte (
    constant item : item_t)
    return integer;
  impure function to_item (
    constant value : integer_vector_ptr_t)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return integer_vector_ptr_t;
  impure function to_item (
    constant value : string_ptr_t)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return string_ptr_t;
  impure function to_item (
    constant value : string_ptr_vector_ptr_t)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return string_ptr_vector_ptr_t;

  -----------------------------------------------------------------------------
  -- Aliases
  -----------------------------------------------------------------------------
  alias boolean_to_item is to_item[boolean return item_t];
  alias to_boolean is from_item[item_t return boolean];
  alias bit_to_item is to_item[bit return item_t];
  alias to_bit is from_item[item_t return bit];
  alias bit_vector_to_item is to_item[bit_vector return item_t];
  alias to_bit_vector is from_item[item_t return bit_vector];
  alias character_to_item is to_item[character return item_t];
  alias to_character is from_item[item_t return character];
  alias string_to_item is to_item[string return item_t];
  alias to_string is from_item[item_t return string];
  alias integer_to_item is to_item[integer return item_t];
  alias to_integer is from_item[item_t return integer];
  alias real_to_item is to_item[real return item_t];
  alias to_real is from_item[item_t return real];
  alias time_to_item is to_item[time return item_t];
  alias to_time is from_item[item_t return time];
  alias severity_level_to_item is to_item[severity_level return item_t];
  alias to_severity_level is from_item[item_t return severity_level];
  alias file_open_status_to_item is to_item[file_open_status return item_t];
  alias to_file_open_status is from_item[item_t return file_open_status];
  alias file_open_kind_to_item is to_item[file_open_kind return item_t];
  alias to_file_open_kind is from_item[item_t return file_open_kind];

  alias numeric_bit_unsigned_to_item is to_item[ieee.numeric_bit.unsigned return item_t];
  alias to_numeric_bit_unsigned is from_item[item_t return ieee.numeric_bit.unsigned];
  alias numeric_bit_signed_to_item is to_item[ieee.numeric_bit.signed return item_t];
  alias to_numeric_bit_signed is from_item[item_t return ieee.numeric_bit.signed];
  alias complex_to_item is to_item[complex return item_t];
  alias to_complex is from_item[item_t return complex];
  alias complex_polar_to_item is to_item[complex_polar return item_t];
  alias to_complex_polar is from_item[item_t return complex_polar];
  alias std_ulogic_to_item is to_item[std_ulogic return item_t];
  alias to_std_ulogic is from_item[item_t return std_ulogic];
  alias std_ulogic_vector_to_item is to_item[std_ulogic_vector return item_t];
  alias to_std_ulogic_vector is from_item[item_t return std_ulogic_vector];
  alias numeric_std_unsigned_to_item is to_item[ieee.numeric_std.unsigned return item_t];
  alias to_numeric_std_unsigned is from_item[item_t return ieee.numeric_std.unsigned];
  alias numeric_std_signed_to_item is to_item[ieee.numeric_std.signed return item_t];
  alias to_numeric_std_signed is from_item[item_t return ieee.numeric_std.signed];

  alias type_t_to_item is to_item[type_t return item_t];
  alias to_type_t is from_item[item_t return type_t];
  alias range_t_to_item is to_item[range_t return item_t];
  alias to_range_t is from_item[item_t return range_t];
  alias integer_vector_ptr_t_to_item is to_item[integer_vector_ptr_t return item_t];
  alias to_integer_vector_ptr_t is from_item[item_t return integer_vector_ptr_t];
  alias string_ptr_t_to_item is to_item[string_ptr_t return item_t];
  alias to_string_ptr_t is from_item[item_t return string_ptr_t];
  alias string_ptr_vector_ptr_t_to_item is to_item[string_ptr_vector_ptr_t return item_t];
  alias to_string_ptr_vector_ptr_t is from_item[item_t return string_ptr_vector_ptr_t];

end package;

package body item_pkg is

  function new_item (
    constant typ  : type_t;
    constant code : string)
    return item_t
  is
  begin
    return encode(typ) & code;
  end;

  function get_type (
    constant item : item_t)
    return type_t
  is
  begin
    return decode(item(1 to 1));
  end;

  function get_code (
    constant item : item_t)
    return string
  is
  begin
    return item(2 to item'right);
  end;

  impure function trim_type (
    constant item : item_t;
    constant typ  : type_t)
    return string
  is
  begin
    check_type(get_type(item), typ);
    return get_code(item);
  end;

  -----------------------------------------------------------------------------
  -- VHDL types
  -----------------------------------------------------------------------------
  impure function to_item (
    constant value : boolean)
    return item_t
  is
  begin
    return encode(vhdl_boolean) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return boolean
  is
  begin
    return decode(trim_type(item, vhdl_boolean));
  end;

  impure function to_item (
    constant value : bit)
    return item_t
  is
  begin
    return encode(vhdl_bit) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return bit
  is
  begin
    return decode(trim_type(item, vhdl_bit));
  end;

  impure function to_item (
    constant value : bit_vector)
    return item_t
  is
  begin
    return encode(vhdl_bit_vector) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return bit_vector
  is
  begin
    return decode(trim_type(item, vhdl_bit_vector));
  end;

  impure function to_item (
    constant value : character)
    return item_t
  is
  begin
    return encode(vhdl_character) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return character
  is
  begin
    return decode(trim_type(item, vhdl_character));
  end;

  impure function to_item (
    constant value : string)
    return item_t
  is
  begin
    return encode(vhdl_string) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return string
  is
  begin
    return decode(trim_type(item, vhdl_string));
  end;

  impure function to_item (
    constant value : integer)
    return item_t
  is
  begin
    return encode(vhdl_integer) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return integer
  is
  begin
    return decode(trim_type(item, vhdl_integer));
  end;

  impure function to_item (
    constant value : real)
    return item_t
  is
  begin
    return encode(vhdl_real) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return real
  is
  begin
    return decode(trim_type(item, vhdl_real));
  end;

  impure function to_item (
    constant value : time)
    return item_t
  is
  begin
    return encode(vhdl_time) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return time
  is
  begin
    return decode(trim_type(item, vhdl_time));
  end;

  impure function to_item (
    constant value : severity_level)
    return item_t
  is
  begin
    return encode(vhdl_severity_level) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return severity_level
  is
  begin
    return decode(trim_type(item, vhdl_severity_level));
  end;

  impure function to_item (
    constant value : file_open_status)
    return item_t
  is
  begin
    return encode(vhdl_file_open_status) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return file_open_status
  is
  begin
    return decode(trim_type(item, vhdl_file_open_status));
  end;

  impure function to_item (
    constant value : file_open_kind)
    return item_t
  is
  begin
    return encode(vhdl_file_open_kind) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return file_open_kind
  is
  begin
    return decode(trim_type(item, vhdl_file_open_kind));
  end;

  -----------------------------------------------------------------------------
  -- IEEE types
  -----------------------------------------------------------------------------
  impure function to_item (
    constant value : ieee.numeric_bit.unsigned)
    return item_t
  is
  begin
    return encode(ieee_numeric_bit_unsigned) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return ieee.numeric_bit.unsigned
  is
  begin
    return decode(trim_type(item, ieee_numeric_bit_unsigned));
  end;

  impure function to_item (
    constant value : ieee.numeric_bit.signed)
    return item_t
  is
  begin
    return encode(ieee_numeric_bit_signed) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return ieee.numeric_bit.signed
  is
  begin
    return decode(trim_type(item, ieee_numeric_bit_signed));
  end;

  impure function to_item (
    constant value : complex)
    return item_t
  is
  begin
    return encode(ieee_complex) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return complex
  is
  begin
    return decode(trim_type(item, ieee_complex));
  end;

  impure function to_item (
    constant value : complex_polar)
    return item_t
  is
  begin
    return encode(ieee_complex_polar) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return complex_polar
  is
  begin
    return decode(trim_type(item, ieee_complex_polar));
  end;

  impure function to_item (
    constant value : std_ulogic)
    return item_t
  is
  begin
    return encode(ieee_std_ulogic) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return std_ulogic
  is
  begin
    return decode(trim_type(item, ieee_std_ulogic));
  end;

  impure function to_item (
    constant value : std_ulogic_vector)
    return item_t
  is
  begin
    return encode(ieee_std_ulogic_vector) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return std_ulogic_vector
  is
  begin
    return decode(trim_type(item, ieee_std_ulogic_vector));
  end;

  impure function to_item (
    constant value : ieee.numeric_std.unsigned)
    return item_t
  is
  begin
    return encode(ieee_numeric_std_unsigned) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return ieee.numeric_std.unsigned
  is
  begin
    return decode(trim_type(item, ieee_numeric_std_unsigned));
  end;

  impure function to_item (
    constant value : ieee.numeric_std.signed)
    return item_t
  is
  begin
    return encode(ieee_numeric_std_signed) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return ieee.numeric_std.signed
  is
  begin
    return decode(trim_type(item, ieee_numeric_std_signed));
  end;

  -----------------------------------------------------------------------------
  -- VUnit types
  -----------------------------------------------------------------------------
  impure function to_item (
    constant value : type_t)
    return item_t
  is
  begin
    return encode(vunit_type) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return type_t
  is
  begin
    return decode(trim_type(item, vunit_type));
  end;

  impure function to_item (
    constant value : range_t)
    return item_t
  is
  begin
    return encode(vunit_range) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return range_t
  is
  begin
    return decode(trim_type(item, vunit_range));
  end;

  impure function byte_to_item (
    constant value : natural range 0 to 255)
    return item_t
  is
  begin
    return encode(vunit_byte) & encode_byte(value);
  end;

  impure function to_byte (
    constant item : item_t)
    return integer
  is
  begin
    return decode_byte(trim_type(item, vunit_byte));
  end;

  impure function to_item (
    constant value : integer_vector_ptr_t)
    return item_t
  is
  begin
    return encode(vunit_integer_vector_ptr) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return integer_vector_ptr_t
  is
  begin
    return decode(trim_type(item, vunit_integer_vector_ptr));
  end;

  impure function to_item (
    constant value : string_ptr_t)
    return item_t
  is
  begin
    return encode(vunit_string_ptr) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return string_ptr_t
  is
  begin
    return decode(trim_type(item, vunit_string_ptr));
  end;

  impure function to_item (
    constant value : string_ptr_vector_ptr_t)
    return item_t
  is
  begin
    return encode(vunit_string_ptr_vector_ptr) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return string_ptr_vector_ptr_t
  is
  begin
    return decode(trim_type(item, vunit_string_ptr_vector_ptr));
  end;

end package body;

