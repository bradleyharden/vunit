-- This package contains support functions for standard codec building
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

use work.type_pkg.all;
use work.codec_builder_pkg.all;

package codec_builder_2008_pkg is

  procedure encode (
    constant data  :       boolean_vector;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   boolean_vector);
  procedure encode (
    constant data  :       integer_vector;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   integer_vector);
  procedure encode (
    constant data  :       real_vector;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   real_vector);
  procedure encode (
    constant data  :       time_vector;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   time_vector);
  procedure encode (
    constant data  :       ufixed;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   ufixed);
  procedure encode (
    constant data  :       sfixed;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   sfixed);
  procedure encode (
    constant data  :       float;
    variable index : inout positive;
    variable code  : inout string);
  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   float);

end package codec_builder_2008_pkg;

package body codec_builder_2008_pkg is

  procedure encode (
    constant data  :       boolean_vector;
    variable index : inout positive;
    variable code  : inout string)
  is
    variable value : bit_vector(data'range);
  begin
    for i in data'range loop
      value(i) := '1' when data(i) else '0';
    end loop;
    encode(value, index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   boolean_vector)
  is
    variable value : bit_vector(data'range);
  begin
    decode(code, index, value);
    for i in data'range loop
      data(i) := value(i) = '1';
    end loop;
  end;

  procedure encode (
    constant data  :       integer_vector;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    for i in data'range loop
      encode(data(i), index, code);
    end loop;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   integer_vector)
  is
  begin
    for i in data'range loop
      decode(code, index, data(i));
    end loop;
  end;

  procedure encode (
    constant data  :       real_vector;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    for i in data'range loop
      encode(data(i), index, code);
    end loop;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   real_vector)
  is
  begin
    for i in data'range loop
      decode(code, index, data(i));
    end loop;
  end;

  procedure encode (
    constant data  :       time_vector;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    for i in data'range loop
      encode(data(i), index, code);
    end loop;
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   time_vector)
  is
  begin
    for i in data'range loop
      decode(code, index, data(i));
    end loop;
  end;

  procedure encode (
    constant data  :       ufixed;
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
    variable data  : out   ufixed)
  is
    variable value : std_ulogic_array(data'range);
  begin
    decode(code, index, value);
    data := ufixed(value);
  end;

  procedure encode (
    constant data  :       sfixed;
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
    variable data  : out   sfixed)
  is
    variable value : std_ulogic_array(data'range);
  begin
    decode(code, index, value);
    data := sfixed(value);
  end;

  procedure encode (
    constant data  :       float;
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
    variable data  : out   float)
  is
    variable value : std_ulogic_array(data'range);
  begin
    decode(code, index, value);
    data := float(value);
  end;

end package body codec_builder_2008_pkg;

