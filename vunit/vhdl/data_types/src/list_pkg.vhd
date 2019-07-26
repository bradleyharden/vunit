-- This file provides functionality to encode/decode standard types to/from string.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

use work.string_ptr_pkg.all;
use work.string_ptr_vector_ptr_pkg.all;
use work.type_pkg.all;
use work.item_pkg.all;
use work.slice_pkg;

package list_pkg is

  type list_t is record
    p_list   : string_ptr_vector_ptr_t;
    p_length : natural;
  end record;

  constant null_list : list_t := (p_list => null_string_ptr_vector_ptr,
                                  p_length => 0);

  impure function new_list
    return list_t;

  procedure deallocate (
    list : inout list_t);

  function length (
    list : list_t)
    return natural;

  impure function get (
    list  : list_t;
    index : integer)
    return item_t;

  procedure set (
    list  : list_t;
    index : integer;
    item  : item_t);

  procedure insert (
    list  : inout list_t;
    index : integer;
    item  : item_t);

  procedure delete (
    list  : inout list_t;
    index : integer);

  procedure append (
    list : inout list_t;
    item : item_t);

  procedure extend (
    list : inout list_t;
    ext  : list_t);

  impure function copy (
    list : list_t)
    return list_t;

end package;

package body list_pkg is

  impure function new_list
    return list_t
  is
  begin
    return (p_list => new_string_ptr_vector_ptr(16), p_length => 0);
  end;

  procedure deallocate (
    list : inout list_t)
  is
  begin
    deallocate(list.p_list);
    list := null_list;
  end;

  function length (
    list : list_t)
    return natural
  is
  begin
    return list.p_length;
  end;

  impure function get (
    list  : list_t;
    index : integer)
    return item_t
  is
    variable i : integer;
  begin
    assert list /= null_list report "get from null list";
    i := slice_pkg.index(index, list.p_length);
    return get_string(list.p_list, i);
  end;

  procedure set (
    list  : list_t;
    index : integer;
    item  : item_t)
  is
    variable i : integer;
  begin
    assert list /= null_list report "set in null list";
    i := slice_pkg.index(index, list.p_length);
    set(list.p_list, i, item);
  end;

  procedure insert (
    list  : inout list_t;
    index : integer;
    item  : item_t)
  is
    variable i : integer;
  begin
    assert list /= null_list report "insert in null list";
    i := slice_pkg.index(index, list.p_length, false);
    if list.p_length = length(list.p_list) then
      resize(list.p_list, 2 * length(list.p_list));
    end if;
    for j in list.p_length - 1 downto i loop
      set(list.p_list, j + 1, get_string_ptr(list.p_list, j));
    end loop;
    set(list.p_list, i, item);
    list.p_length := list.p_length + 1;
  end;

  procedure delete (
    list  : inout list_t;
    index : integer)
  is
    variable i : integer;
    variable string_ptr : string_ptr_t;
  begin
    assert list /= null_list report "delete from null list";
    i := slice_pkg.index(index, list.p_length, false);
    string_ptr := get(list.p_list, i);
    deallocate(string_ptr);
    for j in i to list.p_length - 2 loop
      string_ptr := get(list.p_list, j + 1);
      set(list.p_list, j, string_ptr);
    end loop;
    list.p_length := list.p_length - 1;
  end;

  impure function slice (
    list  : list_t;
    slice : slice_pkg.slice_t)
    return list_t
  is
    variable indices : slice_pkg.indices_t;
    variable start : natural;
    variable stop  : natural;
    variable step  : integer;
    variable i     : integer;
    variable ret   : list_t;
  begin
    assert list /= null_list report "slice from null list";
    indices := slice_pkg.indices(slice, list.p_length, false);
    start := indices(1);
    stop  := indices(2);
    step  := indices(3);
    i := start;
    ret := new_list;
    loop
      append(ret, get(list, i));
      i := i + step;
      exit when (step > 0 and i >= stop) or (step < 0 and i <= stop);
    end loop;
    return ret;
  end;

  procedure append (
    list : inout list_t;
    item : item_t)
  is
  begin
    insert(list, list.p_length, item);
  end;

  procedure extend (
    list : inout list_t;
    ext  : list_t)
  is
    constant new_length : natural := list.p_length + ext.p_length;
  begin
    if new_length > length(list.p_list) then
      if list.p_length > ext.p_length then
        resize(list.p_list, 2 * list.p_length);
      else
        resize(list.p_list, 2 * ext.p_length);
      end if;
    end if;
    for i in list.p_length to new_length - 1 loop
      set(list.p_list, i, get_string_ptr(ext.p_list, i - list.p_length));
    end loop;
    list.p_length := new_length;
  end;

  impure function copy (
    list : list_t)
    return list_t
  is
    variable cpy : list_t;
  begin
    if list = null_list then
      return list;
    else
      cpy.p_list := copy(list.p_list);
      cpy.p_length := list.p_length;
      return cpy;
    end if;
  end;

end package body;

