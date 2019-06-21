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
use ieee.fixed_pkg.all;
use ieee.float_pkg.all;

use std.textio.all;

use work.types_pkg.all;

package codec_2008_pkg is
  -----------------------------------------------------------------------------
  -- Predefined composite types
  -----------------------------------------------------------------------------
  function encode (
    constant data : boolean_vector)
    return string;
  function decode (
    constant code : string)
    return boolean_vector;
  function encode (
    constant data : integer_vector)
    return string;
  function decode (
    constant code : string)
    return integer_vector;
  function encode (
    constant data : real_vector)
    return string;
  function decode (
    constant code : string)
    return real_vector;
  function encode (
    constant data : time_vector)
    return string;
  function decode (
    constant code : string)
    return time_vector;
  function encode (
    constant data : ufixed)
    return string;
  function decode (
    constant code : string)
    return ufixed;
  function encode (
    constant data : sfixed)
    return string;
  function decode (
    constant code : string)
    return sfixed;
  function encode (
    constant data : float)
    return string;
  function decode (
    constant code : string)
    return float;

  -----------------------------------------------------------------------------
  -- Aliases
  -----------------------------------------------------------------------------
  alias encode_boolean_vector is encode[boolean_vector return string];
  alias decode_boolean_vector is decode[string return boolean_vector];
  alias encode_integer_vector is encode[integer_vector return string];
  alias decode_integer_vector is decode[string return integer_vector];
  alias encode_real_vector is encode[real_vector return string];
  alias decode_real_vector is decode[string return real_vector];
  alias encode_time_vector is encode[time_vector return string];
  alias decode_time_vector is decode[string return time_vector];
  alias encode_ufixed is encode[ufixed return string];
  alias decode_ufixed is decode[string return ufixed];
  alias encode_sfixed is encode[sfixed return string];
  alias decode_sfixed is decode[string return sfixed];
  alias encode_float is encode[float return string];
  alias decode_float is decode[string return float];

end package;

use work.codec_pkg.all;
use work.codec_builder_2008_pkg.all;

package body codec_2008_pkg is

  -----------------------------------------------------------------------------
  -- Predefined composite types
  -----------------------------------------------------------------------------
  function encode (
    constant data : boolean_vector)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_boolean_vector, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return boolean_vector
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : boolean_vector(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : integer_vector)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_integer_vector, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return integer_vector
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : integer_vector(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : real_vector)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_real_vector, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return real_vector
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : real_vector(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : time_vector)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(vhdl_time_vector, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return time_vector
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : time_vector(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : ufixed)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_ufixed, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return ufixed
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : ufixed(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : sfixed)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_sfixed, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return sfixed
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : sfixed(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

  function encode (
    constant data : float)
    return string
  is
    constant rng   : range_t(data'range) := (others => '0');
    variable index : positive := 1;
    variable code  : string(1 to code_length(ieee_float, data'length));
  begin
    encode(data, index, code);
    return encode(rng) & code;
  end;

  function decode (
    constant code : string)
    return float
  is
    constant rng   : range_t := decode(code);
    variable index : positive := code'left + code_length(vunit_range);
    variable data  : float(rng'range);
  begin
    decode(code, index, data);
    return data;
  end;

end package body codec_2008_pkg;

