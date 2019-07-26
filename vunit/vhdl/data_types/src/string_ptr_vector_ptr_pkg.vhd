-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com
--
--

use work.integer_vector_ptr_pkg.all;
use work.string_ptr_pkg.all;

package string_ptr_vector_ptr_pkg is

  type string_ptr_vector_ptr_t is record
    p_ivp : integer_vector_ptr_t;
  end record;

  alias ptr_t is string_ptr_vector_ptr_t;

  constant null_string_ptr_vector_ptr : ptr_t := (p_ivp => null_integer_vector_ptr);

  alias index_t is work.integer_vector_ptr_pkg.index_t;

  function to_integer (
    value : ptr_t)
    return index_t;

  impure function to_string_ptr_vector_ptr (
    value : index_t)
    return ptr_t;

  impure function new_string_ptr_vector_ptr (
    length : natural := 0)
    return ptr_t;

  procedure deallocate (
    ptr : inout ptr_t);

  impure function length (
    ptr : ptr_t)
    return natural;

  procedure set (
    ptr   : ptr_t;
    index : natural;
    value : string_ptr_t);

  procedure set (
    ptr   : ptr_t;
    index : natural;
    value : string);

  impure function get (
    ptr   : ptr_t;
    index : natural)
    return string_ptr_t;

  impure function get (
    ptr   : ptr_t;
    index : natural)
    return string;

  alias set_string_ptr is set[ptr_t, natural, string_ptr_t];
  alias get_string_ptr is get[ptr_t, natural return string_ptr_t];

  alias set_string is set[ptr_t, natural, string];
  alias get_string is get[ptr_t, natural return string];

  procedure resize (
    ptr    : ptr_t;
    length : natural;
    drop   : natural := 0;
    rotate : natural := 0);

  impure function copy (
    ptr : ptr_t)
    return ptr_t;

end package;

package body string_ptr_vector_ptr_pkg is

  function to_integer (
    value : ptr_t)
    return index_t
  is
  begin
    return value.p_ivp.ref;
  end;

  impure function to_string_ptr_vector_ptr (
    value : index_t)
    return ptr_t
  is
  begin
    return (p_ivp => to_integer_vector_ptr(value));
  end;

  impure function new_string_ptr_vector_ptr (
    length : natural := 0)
    return ptr_t
  is
  begin
    return (p_ivp => new_integer_vector_ptr(length, -1));
  end;

  procedure deallocate (
    ptr : inout ptr_t)
  is 
    variable string_ptr : string_ptr_t;
  begin
    if ptr /= null_string_ptr_vector_ptr then
      for i in 0 to length(ptr.p_ivp) - 1 loop
        string_ptr := to_string_ptr(get(ptr.p_ivp, i));
        deallocate(string_ptr);
      end loop;
      deallocate(ptr.p_ivp);
      ptr := null_string_ptr_vector_ptr;
    end if;
  end;

  impure function length (
    ptr : ptr_t)
    return natural
  is
  begin
    return length(ptr.p_ivp);
  end;

  procedure set (
    ptr   : ptr_t;
    index : natural;
    value : string_ptr_t)
  is
  begin
    set(ptr.p_ivp, index, to_integer(value));
  end;

  procedure set (
    ptr   : ptr_t;
    index : natural;
    value : string)
  is
    variable string_ptr : string_ptr_t;
  begin
    string_ptr := get(ptr, index);
    if string_ptr = null_string_ptr then
      string_ptr := new_string_ptr(value);
      set(ptr, index, string_ptr);
    else
      reallocate(string_ptr, value);
    end if;
  end;

  impure function get (
    ptr   : ptr_t;
    index : natural)
    return string_ptr_t
  is
  begin
    return to_string_ptr(get(ptr.p_ivp, index));
  end;

  impure function get (
    ptr   : ptr_t;
    index : natural)
  return string
  is
  begin
    return to_string(get_string_ptr(ptr, index));
  end;

  procedure resize (
    ptr    : ptr_t;
    length : natural;
    drop   : natural := 0;
    rotate : natural := 0)
  is
  begin
    resize(ptr.p_ivp, length, drop, -1, rotate);
  end;

  impure function copy (
    ptr : ptr_t)
    return ptr_t
  is
    variable len : natural;
    variable cpy : ptr_t;
  begin
    if ptr = null_string_ptr_vector_ptr then
      return ptr;
    else
      len := length(ptr);
      cpy := new_string_ptr_vector_ptr(len);
      for i in 0 to len - 1 loop
        set(cpy, i, copy(get_string_ptr(ptr, i)));
      end loop;
      return cpy;
    end if;
  end;

end package body;

