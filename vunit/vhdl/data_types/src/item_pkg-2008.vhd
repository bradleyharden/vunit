-- This file provides functionality to encode/decode standard types to/from string.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

library ieee;
use ieee.fixed_pkg.all;
use ieee.float_pkg.all;

use work.type_pkg.all;
use work.codec_pkg.all;
use work.codec_2008_pkg.all;
use work.item_pkg.all;

package item_2008_pkg is

  impure function to_item (
    constant value : boolean_vector)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return boolean_vector;
  impure function to_item (
    constant value : integer_vector)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return integer_vector;
  impure function to_item (
    constant value : real_vector)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return real_vector;
  impure function to_item (
    constant value : time_vector)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return time_vector;
  impure function to_item (
    constant value : ufixed)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return ufixed;
  impure function to_item (
    constant value : sfixed)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return sfixed;
  impure function to_item (
    constant value : float)
    return item_t;
  impure function from_item (
    constant item : item_t)
    return float;

  alias boolean_vector_to_item is to_item[boolean_vector return item_t];
  alias to_boolean_vector is from_item[item_t return boolean_vector];
  alias integer_vector_to_item is to_item[integer_vector return item_t];
  alias to_integer_vector is from_item[item_t return integer_vector];
  alias real_vector_to_item is to_item[real_vector return item_t];
  alias to_real_vector is from_item[item_t return real_vector];
  alias time_vector_to_item is to_item[time_vector return item_t];
  alias to_time_vector is from_item[item_t return time_vector];
  alias ufixed_to_item is to_item[ufixed return item_t];
  alias to_ufixed is from_item[item_t return ufixed];
  alias sfixed_to_item is to_item[sfixed return item_t];
  alias to_sfixed is from_item[item_t return sfixed];
  alias float_to_item is to_item[float return item_t];
  alias to_float is from_item[item_t return float];

end package;

package body item_2008_pkg is

  impure function to_item (
    constant value : boolean_vector)
    return item_t
  is
  begin
    return encode(vhdl_boolean_vector) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return boolean_vector
  is
  begin
    return decode(trim_type(item, vhdl_boolean_vector));
  end;

  impure function to_item (
    constant value : integer_vector)
    return item_t
  is
  begin
    return encode(vhdl_integer_vector) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return integer_vector
  is
  begin
    return decode(trim_type(item, vhdl_integer_vector));
  end;

  impure function to_item (
    constant value : real_vector)
    return item_t
  is
  begin
    return encode(vhdl_real_vector) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return real_vector
  is
  begin
    return decode(trim_type(item, vhdl_real_vector));
  end;

  impure function to_item (
    constant value : time_vector)
    return item_t
  is
  begin
    return encode(vhdl_time_vector) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return time_vector
  is
  begin
    return decode(trim_type(item, vhdl_time_vector));
  end;

  impure function to_item (
    constant value : ufixed)
    return item_t
  is
  begin
    return encode(ieee_ufixed) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return ufixed
  is
  begin
    return decode(trim_type(item, ieee_ufixed));
  end;

  impure function to_item (
    constant value : sfixed)
    return item_t
  is
  begin
    return encode(ieee_sfixed) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return sfixed
  is
  begin
    return decode(trim_type(item, ieee_sfixed));
  end;

  impure function to_item (
    constant value : float)
    return item_t
  is
  begin
    return encode(ieee_float) & encode(value);
  end;

  impure function from_item (
    constant item : item_t)
    return float
  is
  begin
    return decode(trim_type(item, ieee_float));
  end;

end package body;

