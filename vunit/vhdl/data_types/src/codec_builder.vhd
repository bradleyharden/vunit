-- This package contains support functions for standard codec building
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.math_complex.all;
use ieee.numeric_bit.all;
use ieee.numeric_std.all;

use std.textio.all;

use work.integer_vector_ptr_pkg.all;
use work.string_ptr_pkg.all;
use work.string_ptr_vector_ptr_pkg.all;
use work.type_pkg.all;

package codec_builder_pkg is

  type std_ulogic_array is array (integer range <>) of std_ulogic;

  function get_simulator_resolution return time;

  function code_length (
    constant typ    : type_t;
    constant length : natural := 1)
    return natural;

  procedure encode (
    constant data  :       integer;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   integer);
  procedure encode (
    constant data  :       real;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   real);
  procedure encode (
    constant data  :       time;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   time);
  procedure encode (
    constant data  :       boolean;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   boolean);
  procedure encode (
    constant data  :       bit;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   bit);
  procedure encode (
    constant data  :       std_ulogic;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   std_ulogic);
  procedure encode (
    constant data  :       severity_level;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   severity_level);
  procedure encode (
    constant data  :       file_open_status;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   file_open_status);
  procedure encode (
    constant data  :       file_open_kind;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   file_open_kind);
  procedure encode (
    constant data  :       character;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   character);

  procedure encode (
    constant data  :       std_ulogic_array;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   std_ulogic_array);
  procedure encode (
    constant data  :       string;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   string);
  procedure encode (
    constant data  :       bit_vector;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   bit_vector);
  procedure encode (
    constant data  :       std_ulogic_vector;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   std_ulogic_vector);
  procedure encode (
    constant data  :       complex;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   complex);
  procedure encode (
    constant data  :       complex_polar;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   complex_polar);
  procedure encode (
    constant data  :       ieee.numeric_bit.unsigned;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   ieee.numeric_bit.unsigned);
  procedure encode (
    constant data  :       ieee.numeric_bit.signed;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   ieee.numeric_bit.signed);
  procedure encode (
    constant data  :       ieee.numeric_std.unsigned;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   ieee.numeric_std.unsigned);
  procedure encode (
    constant data  :       ieee.numeric_std.signed;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   ieee.numeric_std.signed);

  procedure encode (
    constant data  :       type_t;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   type_t);
  procedure encode_byte (
    constant data  :       natural range 0 to 255;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode_byte (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   natural range 0 to 255);
  procedure encode (
    constant data  :       integer_vector_ptr_t;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code   :       string;
    variable index  : inout positive;
    variable result : out   integer_vector_ptr_t);
  procedure encode (
    constant data  :       string_ptr_t;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code   :       string;
    variable index  : inout positive;
    variable result : out   string_ptr_t);
  procedure encode (
    constant data  :       string_ptr_vector_ptr_t;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   string_ptr_vector_ptr_t);

end package codec_builder_pkg;

package body codec_builder_pkg is

  function get_simulator_resolution return time is
    type time_array_t is array (integer range <>) of time;
    variable resolution : time;
    constant resolutions : time_array_t(1 to 8) := (
      1.0e-15 sec, 1.0e-12 sec , 1.0e-9 sec, 1.0e-6 sec, 1.0e-3 sec, 1 sec, 1 min, 1 hr);
  begin
    for r in resolutions'range loop
      resolution := resolutions(r);
      exit when resolution > 0 sec;
    end loop;

    return resolution;
  end;

  constant simulator_resolution : time := get_simulator_resolution;

  function size (
    constant typ : type_t)
    return natural is
  begin
    if    typ = null_type                   then return 0;
    elsif typ = vhdl_null                   then return 0;
    elsif typ = vhdl_boolean                then return 1;
    elsif typ = vhdl_boolean_vector         then return size(vhdl_boolean);
    elsif typ = vhdl_bit                    then return 1;
    elsif typ = vhdl_bit_vector             then return size(vhdl_bit);
    elsif typ = vhdl_character              then return 8;
    elsif typ = vhdl_string                 then return size(vhdl_character);
    elsif typ = vhdl_integer                then return 32;
    elsif typ = vhdl_integer_vector         then return size(vhdl_integer);
    elsif typ = vhdl_real                   then return 64;
    elsif typ = vhdl_real_vector            then return size(vhdl_real);
    elsif typ = vhdl_time                   then return 64;
    elsif typ = vhdl_time_vector            then return size(vhdl_time);
    elsif typ = vhdl_severity_level         then return 8;
    elsif typ = vhdl_file_open_status       then return 8;
    elsif typ = vhdl_file_open_kind         then return 8;
    elsif typ = ieee_numeric_bit_unsigned   then return size(vhdl_bit);
    elsif typ = ieee_numeric_bit_signed     then return size(vhdl_bit);
    elsif typ = ieee_complex                then return 2 * size(vhdl_real);
    elsif typ = ieee_complex_polar          then return 2 * size(vhdl_real);
    elsif typ = ieee_std_ulogic             then return 4;
    elsif typ = ieee_std_ulogic_vector      then return size(ieee_std_ulogic);
    elsif typ = ieee_numeric_std_unsigned   then return size(ieee_std_ulogic);
    elsif typ = ieee_numeric_std_signed     then return size(ieee_std_ulogic);
    elsif typ = ieee_ufixed                 then return size(ieee_std_ulogic);
    elsif typ = ieee_sfixed                 then return size(ieee_std_ulogic);
    elsif typ = ieee_float                  then return size(ieee_std_ulogic);
    elsif typ = vunit_type                  then return 8;
    elsif typ = vunit_range                 then return 2 * size(vhdl_integer) + size(vhdl_boolean);
    elsif typ = vunit_byte                  then return 8;
    elsif typ = vunit_integer_vector_ptr    then return size(vhdl_integer);
    elsif typ = vunit_string_ptr            then return size(vhdl_integer);
    elsif typ = vunit_string_ptr_vector_ptr then return size(vunit_integer_vector_ptr);
    else
      report "invalid type" severity failure;
    end if;
  end function;

  function code_length (
    constant typ    : type_t;
    constant length : natural := 1)
    return natural
  is
    constant siz   : natural := size(typ);
    constant bytes : natural := siz / 8;
    constant bits  : natural := siz mod 8;
  begin
    return bytes * length + (bits * length + 7) / 8;
  end;

  procedure encode (
    constant data  :       integer;
    variable index : inout positive;
    variable code  : inout string)
  is
    variable value : ieee.numeric_bit.signed(31 downto 0);
  begin
    value := to_signed(data, 32);
    encode(value, index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   integer)
  is
    variable value : ieee.numeric_bit.signed(31 downto 0);
  begin
    decode(code, index, value);
    data := to_integer(value);
  end;

  procedure encode (
    constant data  :       real;
    variable index : inout positive;
    variable code  : inout string)
  is

    function log2 (a : real) return integer is
      variable y : real := a;
      variable n : integer := 0;
    begin
      while y >= 2.0 and n < 1024 loop
        y := y / 2.0;
        n := n + 1;
      end loop;
      while y < 1.0 and n > -1023 loop
        y := y * 2.0;
        n := n - 1;
      end loop;
      return n;
    end function;

    variable value : real    := data;
    constant sign  : boolean := data < 0.0;
    variable exp   : integer;
    variable high  : natural;
    variable low   : natural;
    variable bits  : ieee.numeric_bit.unsigned(63 downto 0);
    -- Encode as IEEE 754 binary64
    -- Drop mantissa MSB by overwriting with exponent
    alias bits_sign : bit is bits(63);
    alias bits_exp  : ieee.numeric_bit.unsigned(10 downto 0) is bits(62 downto 52);
    alias bits_high : ieee.numeric_bit.unsigned(21 downto 0) is bits(52 downto 31);
    alias bits_low  : ieee.numeric_bit.unsigned(30 downto 0) is bits(30 downto 0);
  begin
    if sign then
      value := -value;
    end if;
    exp := log2(value);
    if exp > -1023 then
      value := value * 2.0 ** (-exp);
    else
      value := value * 2.0 ** 1022;
    end if;
    value := value * 2.0 ** 52;
    high := integer(floor(value * 2.0 ** (-31)));
    low := integer(value - real(high) * 2.0 ** 31);
    bits_low  := to_unsigned(low, 31);
    bits_high := to_unsigned(high, 22);
    bits_exp  := to_unsigned(exp + 1023, 11);
    bits_sign := bit'val(boolean'pos(sign));
    encode(bits, index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   real)
  is
    variable bits  : ieee.numeric_bit.unsigned(63 downto 0);
    variable sign  : boolean;
    variable exp   : integer;
    variable high  : natural;
    variable low   : natural;
    variable value : real;
    -- Decode as IEEE 754 binary64
    alias bits_sign : bit is bits(63);
    alias bits_exp  : ieee.numeric_bit.unsigned(10 downto 0) is bits(62 downto 52);
    alias bits_high : ieee.numeric_bit.unsigned(20 downto 0) is bits(51 downto 31);
    alias bits_low  : ieee.numeric_bit.unsigned(30 downto 0) is bits(30 downto 0);
  begin
    decode(code, index, bits);
    sign := bits_sign = '1';
    exp  := to_integer(bits_exp) - 1023;
    high := to_integer(bits_high);
    low  := to_integer(bits_low);
    value := (real(low) + real(high) * 2.0 ** 31) * 2.0 ** (-52);
    if exp > -1023 then
      value := value + 1.0;
      value := value * 2.0 ** exp;
    else
      value := value * 2.0 ** (-1022);
    end if;
    if sign then
      value := -value;
    end if;
    data := value;
  end;

  procedure encode (
    constant data  :       time;
    variable index : inout positive;
    variable code  : inout string)
  is

    function modulo (
      t : time;
      m : natural)
    return integer
    is
    begin
      return integer((t - (t/m)*m)/simulator_resolution) mod m;
    end function;

    variable t    : time := data;
    variable byte : natural range 0 to 255;
  begin
    -- @TODO assumes size of time
    for i in code_length(vhdl_time) - 1 downto 0 loop
      byte := modulo(t, 256);
      code(index + i) := character'val(byte);
      t := (t - byte * simulator_resolution) / 256;
    end loop;
    index := index + code_length(vhdl_time);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   time)
  is
    variable byte : integer;
    variable temp : time;
  begin
    -- @TODO assumes size of time
    temp := simulator_resolution * 0;
    for i in 1 to code_length(vhdl_time) loop
      temp := temp * 256;
      byte := character'pos(code(index));
      if i = 1 and byte >= 128 then
        byte := byte - 256;
      end if;
      temp := temp + byte * simulator_resolution;
      index := index + 1;
    end loop;
    data := temp;
  end;

  procedure encode (
    constant data  :       boolean;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    code(index) := character'val(boolean'pos(data));
    index := index + 1;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   boolean)
  is
  begin
    data := boolean'val(character'pos(code(index)));
    index := index + 1;
  end;

  procedure encode (
    constant data  :       bit;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    code(index) := character'val(bit'pos(data));
    index := index + 1;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   bit)
  is
  begin
    data := bit'val(character'pos(code(index)));
    index := index + 1;
  end;

  procedure encode (
    constant data  :       std_ulogic;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    code(index) := character'val(std_ulogic'pos(data));
    index := index + 1;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   std_ulogic)
  is
  begin
    data := std_ulogic'val(character'pos(code(index)));
    index  := index + 1;
  end procedure decode;

  procedure encode (
    constant data  :       severity_level;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    code(index) := character'val(severity_level'pos(data));
    index := index + 1;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   severity_level)
  is
  begin
    data := severity_level'val(character'pos(code(index)));
    index := index + 1;
  end;

  procedure encode (
    constant data  :       file_open_status;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    code(index) := character'val(file_open_status'pos(data));
    index := index + 1;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   file_open_status)
  is
  begin
    data := file_open_status'val(character'pos(code(index)));
    index := index + 1;
  end;

  procedure encode (
    constant data  :       file_open_kind;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    code(index) := character'val(file_open_kind'pos(data));
    index := index + 1;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   file_open_kind)
  is
  begin
    data := file_open_kind'val(character'pos(code(index)));
    index := index + 1;
  end;

  procedure encode (
    constant data  :       character;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    code(index) := data;
    index := index + 1;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   character)
  is
  begin
    data := code(index);
    index := index + 1;
  end;


  procedure encode (
    constant data  :       std_ulogic_array;
    variable index : inout positive;
    variable code  : inout string)
  is
    constant pairs : natural := (data'length + 1) / 2;
    variable value : std_ulogic_array(0 to 2 * pairs - 1);
    variable byte  : natural range 0 to 255;
    variable upper : natural range 0 to 15;
    variable lower : natural range 0 to 15;
  begin
    value(0 to data'length - 1) := data;
    for i in 0 to pairs - 1 loop
      lower := std_ulogic'pos(value(2 * i));
      upper := std_ulogic'pos(value(2 * i + 1));
      byte := upper * 16 + lower;
      code(index) := character'val(byte);
      index := index + 1;
    end loop;
  end; 

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   std_ulogic_array)
  is
    constant pairs : natural := (data'length + 1) / 2;
    variable value : std_ulogic_array(0 to 2 * pairs - 1);
    variable byte  : natural range 0 to 255;
    variable upper : natural range 0 to 15;
    variable lower : natural range 0 to 15;
  begin
    for i in 0 to pairs - 1 loop
      byte := character'pos(code(index));
      upper := byte / 16;
      lower := byte - upper * 16;
      value(2 * i) := std_ulogic'val(lower);
      value(2 * i + 1) := std_ulogic'val(upper);
      index := index + 1;
    end loop;
    data := value(0 to data'length - 1);
  end;

  procedure encode (
    constant data  :       string;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    code(index to index + data'length - 1) := data;
    index := index + data'length;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   string) is
  begin
    data := code(index to index + data'length - 1);
    index := index + data'length;
  end;

  procedure encode (
    constant data  :       bit_vector;
    variable index : inout positive;
    variable code  : inout string)
  is
    constant bytes : natural := (data'length + 7) / 8;
    constant mask  : ieee.numeric_bit.unsigned := to_unsigned(255, data'length);
    variable value : ieee.numeric_bit.unsigned(data'length - 1 downto 0);
    variable byte  : natural range 0 to 255;
  begin
    value := ieee.numeric_bit.unsigned(data);
    for i in 1 to bytes loop
      byte := to_integer(value and mask);
      code(index + bytes - i) := character'val(byte);
      value := value srl 8;
    end loop;
    index := index + bytes;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   bit_vector)
  is
    constant bytes : natural := (data'length + 7) / 8;
    variable value : bit_vector(bytes * 8 - 1 downto 0);
    variable byte  : ieee.numeric_bit.unsigned(7 downto 0);
  begin
    for i in 1 to bytes loop
      value := value sll 8;
      byte := to_unsigned(character'pos(code(index)), 8);
      value(7 downto 0) := bit_vector(byte);
      index := index + 1;
    end loop;
    data := value(data'length - 1 downto 0);
  end;

  procedure encode (
    constant data  :       std_ulogic_vector;
    variable index : inout positive;
    variable code  : inout string)
  is
    variable value : std_ulogic_array(data'range);
  begin
    value := std_ulogic_array(data);
    encode(value, index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   std_ulogic_vector)
  is
    variable value : std_ulogic_array(data'range);
  begin
    if data'length > 0 then
      decode(code, index, value);
      data := std_ulogic_vector(value);
    end if;
  end;

  procedure encode (
    constant data  : complex;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    encode(data.re, index, code);
    encode(data.im, index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   complex)
  is
  begin
    decode(code, index, data.re);
    decode(code, index, data.im);
  end;

  procedure encode (
    constant data  : complex_polar;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    encode(data.mag, index, code);
    encode(data.arg, index, code);
  end;

  procedure decode (
    constant code   :       string;
    variable index  : inout positive;
    variable data : out   complex_polar)
  is
  begin
    decode(code, index, data.mag);
    decode(code, index, data.arg);
  end;

  procedure encode (
    constant data  :       ieee.numeric_bit.unsigned;
    variable index : inout positive;
    variable code  : inout string)
  is
    variable value : bit_vector(data'range);
  begin
    value := bit_vector(data);
    encode(value, index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   ieee.numeric_bit.unsigned)
  is
    variable value : bit_vector(data'range);
  begin
    decode(code, index, value);
    data := ieee.numeric_bit.unsigned(value);
  end;

  procedure encode (
    constant data  :       ieee.numeric_bit.signed;
    variable index : inout positive;
    variable code  : inout string)
  is
    variable value : bit_vector(data'range);
  begin
    value := bit_vector(data);
    encode(value, index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   ieee.numeric_bit.signed)
  is
    variable value : bit_vector(data'range);
  begin
    decode(code, index, value);
    data := ieee.numeric_bit.signed(value);
  end;

  procedure encode (
    constant data  :       ieee.numeric_std.unsigned;
    variable index : inout positive;
    variable code  : inout string)
  is
    variable value : std_ulogic_array(data'range);
  begin
    value := std_ulogic_array(data);
    encode(value, index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   ieee.numeric_std.unsigned)
  is
    variable value : std_ulogic_array(data'range);
  begin
    if data'length > 0 then
      decode(code, index, value);
      data := ieee.numeric_std.unsigned(value);
    end if;
  end;

  procedure encode (
    constant data  :       ieee.numeric_std.signed;
    variable index : inout positive;
    variable code  : inout string)
  is
    variable value : std_ulogic_array(data'range);
  begin
    value := std_ulogic_array(data);
    encode(value, index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   ieee.numeric_std.signed)
  is
    variable value : std_ulogic_array(data'range);
  begin
    if data'length > 0 then
      decode(code, index, value);
      data := ieee.numeric_std.signed(value);
    end if;
  end;

  procedure encode (
    constant data  :       type_t;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    code(index) := character'val(data.p_index + 1);
    index := index + 1;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   type_t)
  is
  begin
    data.p_index := character'pos(code(index)) - 1;
    index := index + 1;
  end;

  procedure encode_byte (
    constant data  :       natural range 0 to 255;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    code(index) := character'val(data);
    index := index + 1;
  end;

  procedure decode_byte (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   natural range 0 to 255)
  is
  begin
    data := character'pos(code(index));
    index := index + 1;
  end;

  procedure encode (
    constant data  :       integer_vector_ptr_t;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    encode(data.ref, index, code);
  end;

  procedure decode (
    constant code   :       string;
    variable index  : inout positive;
    variable result : out   integer_vector_ptr_t)
  is
  begin
    decode(code, index, result.ref);
  end;

  procedure encode (
    constant data  :       string_ptr_t;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    encode(data.ref, index, code);
  end;

  procedure decode (
    constant code   :       string;
    variable index  : inout positive;
    variable result : out   string_ptr_t)
  is
  begin
    decode(code, index, result.ref);
  end;

  procedure encode (
    constant data  :       string_ptr_vector_ptr_t;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    encode(data.p_ivp, index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   string_ptr_vector_ptr_t)
  is
  begin
    decode(code, index, data.p_ivp);
  end;

end package body codec_builder_pkg;

