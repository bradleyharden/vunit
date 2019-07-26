-- This file provides functionality to encode/decode standard types to/from string.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_complex.all;
use ieee.numeric_bit.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all;

use work.type_pkg.all;
use work.codec_builder_pkg.all;
use work.integer_vector_ptr_pkg.all;
use work.string_ptr_pkg.all;
use work.string_ptr_vector_ptr_pkg.all;

package codec_pkg is
  -----------------------------------------------------------------------------
  -- Support
  -----------------------------------------------------------------------------
  type range_t is array (integer range <>) of bit;

  function new_range (
    constant left      : integer := 1;
    constant right     : integer := 0;
    constant ascending : boolean := true)
    return range_t;

  constant null_range : range_t := new_range;

  -----------------------------------------------------------------------------
  -- Predefined scalar types
  -----------------------------------------------------------------------------
  function encode (
    constant data : integer)
    return string;
  function decode (
    constant code : string)
    return integer;
  function encode (
    constant data : real)
    return string;
  function decode (
    constant code : string)
    return real;
  function encode (
    constant data : time)
    return string;
  function decode (
    constant code : string)
    return time;
  function encode (
    constant data : boolean)
    return string;
  function decode (
    constant code : string)
    return boolean;
  function encode (
    constant data : bit)
    return string;
  function decode (
    constant code : string)
    return bit;
  function encode (
    constant data : std_ulogic)
    return string;
  function decode (
    constant code : string)
    return std_ulogic;
  function encode (
    constant data : severity_level)
    return string;
  function decode (
    constant code : string)
    return severity_level;
  function encode (
    constant data : file_open_status)
    return string;
  function decode (
    constant code : string)
    return file_open_status;
  function encode (
    constant data : file_open_kind)
    return string;
  function decode (
    constant code : string)
    return file_open_kind;
  function encode (
    constant data : character)
    return string;
  function decode (
    constant code : string)
    return character;

  -----------------------------------------------------------------------------
  -- Predefined composite types
  -----------------------------------------------------------------------------
  function encode (
    constant data : string)
    return string;
  function decode (
    constant code : string)
    return string;
  function encode (
    constant data : bit_vector)
    return string;
  function decode (
    constant code : string)
    return bit_vector;
  function encode (
    constant data : std_ulogic_vector)
    return string;
  function decode (
    constant code : string)
    return std_ulogic_vector;
  function encode (
    constant data : complex)
    return string;
  function decode (
    constant code : string)
    return complex;
  function encode (
    constant data : complex_polar)
    return string;
  function decode (
    constant code : string)
    return complex_polar;
  function encode (
    constant data : ieee.numeric_bit.unsigned)
    return string;
  function decode (
    constant code : string)
    return ieee.numeric_bit.unsigned;
  function encode (
    constant data : ieee.numeric_bit.signed)
    return string;
  function decode (
    constant code : string)
    return ieee.numeric_bit.signed;
  function encode (
    constant data : ieee.numeric_std.unsigned)
    return string;
  function decode (
    constant code : string)
    return ieee.numeric_std.unsigned;
  function encode (
    constant data : ieee.numeric_std.signed)
    return string;
  function decode (
    constant code : string)
    return ieee.numeric_std.signed;

  -----------------------------------------------------------------------------
  -- VUnit types
  -----------------------------------------------------------------------------
  function encode (
    constant data : type_t)
    return string;
  function decode (
    constant code : string)
    return type_t;
  function encode (
    constant data : range_t)
    return string;
  function decode (
    constant code : string)
    return range_t;
  function encode_byte (
    constant data : natural range 0 to 255)
    return string;
  function decode_byte (
    constant code : string)
    return natural;
  function encode (
    constant data : integer_vector_ptr_t)
    return string;
  function decode (
    constant code : string)
    return integer_vector_ptr_t;
  function encode (
    constant data : string_ptr_t)
    return string;
  function decode (
    constant code : string)
    return string_ptr_t;
  function encode (
    constant data : string_ptr_vector_ptr_t)
    return string;
  function decode (
    constant code : string)
    return string_ptr_vector_ptr_t;

  -----------------------------------------------------------------------------
  -- Aliases
  -----------------------------------------------------------------------------
  alias encode_integer is encode[integer return string];
  alias decode_integer is decode[string return integer];
  alias encode_real is encode[real return string];
  alias decode_real is decode[string return real];
  alias encode_time is encode[time return string];
  alias decode_time is decode[string return time];
  alias encode_boolean is encode[boolean return string];
  alias decode_boolean is decode[string return boolean];
  alias encode_bit is encode[bit return string];
  alias decode_bit is decode[string return bit];
  alias encode_std_ulogic is encode[std_ulogic return string];
  alias decode_std_ulogic is decode[string return std_ulogic];
  alias encode_severity_level is encode[severity_level return string];
  alias decode_severity_level is decode[string return severity_level];
  alias encode_file_open_status is encode[file_open_status return string];
  alias decode_file_open_status is decode[string return file_open_status];
  alias encode_file_open_kind is encode[file_open_kind return string];
  alias decode_file_open_kind is decode[string return file_open_kind];
  alias encode_character is encode[character return string];
  alias decode_character is decode[string return character];

  alias encode_string is encode[string return string];
  alias decode_string is decode[string return string];
  alias encode_bit_vector is encode[bit_vector return string];
  alias decode_bit_vector is decode[string return bit_vector];
  alias encode_std_ulogic_vector is encode[std_ulogic_vector return string];
  alias decode_std_ulogic_vector is decode[string return std_ulogic_vector];
  alias encode_complex is encode[complex return string];
  alias decode_complex is decode[string return complex];
  alias encode_complex_polar is encode[complex_polar return string];
  alias decode_complex_polar is decode[string return complex_polar];
  alias encode_numeric_bit_unsigned is encode[ieee.numeric_bit.unsigned return string];
  alias decode_numeric_bit_unsigned is decode[string return ieee.numeric_bit.unsigned];
  alias encode_numeric_bit_signed is encode[ieee.numeric_bit.signed return string];
  alias decode_numeric_bit_signed is decode[string return ieee.numeric_bit.signed];
  alias encode_numeric_std_unsigned is encode[ieee.numeric_std.unsigned return string];
  alias decode_numeric_std_unsigned is decode[string return ieee.numeric_std.unsigned];
  alias encode_numeric_std_signed is encode[ieee.numeric_std.signed return string];
  alias decode_numeric_std_signed is decode[string return ieee.numeric_std.signed];

  alias encode_type_t is encode[type_t return string];
  alias decode_type_t is decode[string return type_t];
  alias encode_range_t is encode[range_t return string];
  alias decode_range_t is decode[string return range_t];
  alias encode_integer_vector_ptr_t is encode[integer_vector_ptr_t return string];
  alias decode_integer_vector_ptr_t is decode[string return integer_vector_ptr_t];
  alias encode_string_ptr_t is encode[string_ptr_t return string];
  alias decode_string_ptr_t is decode[string return string_ptr_t];
  alias encode_string_ptr_vector_ptr_t is encode[string_ptr_vector_ptr_t return string];
  alias decode_string_ptr_vector_ptr_t is decode[string return string_ptr_vector_ptr_t];

end package;

package body codec_pkg is

  -----------------------------------------------------------------------------
  -- Support
  -----------------------------------------------------------------------------
  function new_range (
    constant left      : integer := 1;
    constant right     : integer := 0;
    constant ascending : boolean := true)
    return range_t
  is
    constant ascending_range : range_t(left to right) := (others => '0');
    constant descending_range : range_t(left downto right) := (others => '0');
  begin
    if ascending then
      return ascending_range;
    else
      return descending_range;
    end if;
  end;

  -----------------------------------------------------------------------------
  -- Predefined scalar types
  -----------------------------------------------------------------------------
  function encode (
    constant data : integer)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_integer));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return integer
  is
    variable index : positive := code'left;
    variable data  : integer;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : real)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_real));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return real
  is
    variable index : positive := code'left;
    variable data  : real;
  begin
    decode(code, index, data);
    return data;
  end;

  constant simulator_resolution : time := get_simulator_resolution;

  function encode (
    constant data : time)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_time));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return time
  is
    variable index : positive := code'left;
    variable data  : time;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : boolean)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_boolean));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return boolean
  is
    variable index : positive := code'left;
    variable data  : boolean;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : bit)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_bit));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return bit
  is
    variable index : positive := code'left;
    variable data  : bit;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : std_ulogic)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_std_ulogic));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return std_ulogic
  is
    variable index : positive := code'left;
    variable data  : std_ulogic;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : severity_level)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_severity_level));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return severity_level
  is
    variable index : positive := code'left;
    variable data  : severity_level;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : file_open_status)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_file_open_status));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return file_open_status
  is
    variable index : positive := code'left;
    variable data  : file_open_status;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : file_open_kind)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_file_open_kind));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return file_open_kind
  is
    variable index : positive := code'left;
    variable data  : file_open_kind;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : character)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_character));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return character
  is
    variable index : positive := code'left;
    variable data  : character;
  begin
    decode(code, index, data);
    return data;
  end;

  -----------------------------------------------------------------------------
  -- Predefined composite types
  -----------------------------------------------------------------------------
  function encode (
    constant data : string)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_string, data'length));
  begin
    -- Modelsim sets data'right to 0 which is out of the positive index range used by strings
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return string
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : string(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : bit_vector)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_bit_vector, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return bit_vector
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : bit_vector(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : std_ulogic_vector)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_std_ulogic_vector, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return std_ulogic_vector
  is
    constant rng   : range_t := decode(code); 
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : std_ulogic_vector(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : complex)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_complex));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return complex
  is
    variable index : positive := code'left;
    variable data  : complex;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : complex_polar)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_complex_polar));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return complex_polar
  is
    variable index : positive := code'left;
    variable data  : complex_polar;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : ieee.numeric_bit.unsigned)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_numeric_bit_unsigned, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return ieee.numeric_bit.unsigned
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : ieee.numeric_bit.unsigned(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : ieee.numeric_bit.signed)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_numeric_bit_signed, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return ieee.numeric_bit.signed
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : ieee.numeric_bit.signed(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : ieee.numeric_std.unsigned)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_numeric_std_unsigned, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return ieee.numeric_std.unsigned
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : ieee.numeric_std.unsigned(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : ieee.numeric_std.signed)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_numeric_std_signed, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return ieee.numeric_std.signed
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : ieee.numeric_std.signed(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  -----------------------------------------------------------------------------
  -- VUnit types
  -----------------------------------------------------------------------------
  function encode (
    constant data : type_t)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vunit_type));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return type_t
  is
    variable index : positive := code'left;
    variable data  : type_t;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : range_t)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vunit_range));
  begin
    encode(data'left, index, code);
    encode(data'right, index, code);
    encode(data'ascending, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return range_t
  is
    variable index     : positive := code'left;
    variable left      : integer;
    variable right     : integer;
    variable ascending : boolean;
  begin
    decode(code, index, left);
    decode(code, index, right);
    decode(code, index, ascending);
    return new_range(left, right, ascending);
  end;

  function encode_byte (
    constant data : natural range 0 to 255)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vunit_byte));
  begin
    encode_byte(data, index, code);
    return code;
  end;

  function decode_byte (
    constant code : string)
    return natural
  is
    variable index : positive := code'left;
    variable data  : natural range 0 to 255;
  begin
    decode_byte(code, index, data);
    return data;
  end;

  function encode (
    constant data : integer_vector_ptr_t)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vunit_integer_vector_ptr));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return integer_vector_ptr_t
  is
    variable index : positive := code'left;
    variable data  : integer_vector_ptr_t;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : string_ptr_t)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vunit_string_ptr));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return string_ptr_t
  is
    variable index : positive := code'left;
    variable data  : string_ptr_t;
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : string_ptr_vector_ptr_t)
    return string
  is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vunit_string_ptr_vector_ptr));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string)
    return string_ptr_vector_ptr_t
  is
    variable index : positive := code'left;
    variable data  : string_ptr_vector_ptr_t;
  begin
    decode(code, index, data);
    return data;
  end;

end package body codec_pkg;

