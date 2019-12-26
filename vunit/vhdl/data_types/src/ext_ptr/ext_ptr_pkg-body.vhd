-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

library vunit_lib;
use vunit_lib.print_pkg.all;

package body ext_ptr_pkg is

  -----------------------------------------------------------------------------
  -- Type definitions
  -----------------------------------------------------------------------------
  function to_integer (
    value : ext_ptr_t
  ) return index_t is begin
    return value.ref;
  end;

  impure function to_ext_ptr (
    value : index_t
  ) return ext_ptr_t is begin
    return (ref => value);
  end;

  -----------------------------------------------------------------------------
  -- VHDL functions
  -----------------------------------------------------------------------------
  impure function new_ext_ptr (
    size : positive;
    name : string  := ""
  ) return ext_ptr_t is
    constant value : string(1 to size) := (others => character'val(0));
  begin
    return new_ext_ptr(value, name);
  end;

  impure function new_ext_ptr (
    value : string;
    name  : string := ""
  ) return ext_ptr_t is
  begin
    return (ref => vhpi_ptr_new_str(value'length, value, name));
  end;

  impure function new_ext_ptr (
    value : integer_vector_t;
    name  : string := ""
  ) return ext_ptr_t is
  begin
    return (ref => vhpi_ptr_new_int(4 * value'length, value, name));
  end;

  procedure reallocate (
    ptr  : ext_ptr_t;
    size : positive
  ) is
    constant value : string(1 to size) := (others => character'val(0));
  begin
    reallocate(ptr, value);
  end;

  procedure reallocate (
    ptr   : ext_ptr_t;
    value : string
  ) is begin
    vhpi_ptr_reallocate_str(ptr.ref, value'length, value);
  end;

  procedure reallocate (
    ptr   : ext_ptr_t;
    value : integer_vector_t
  ) is begin
    vhpi_ptr_reallocate_int(ptr.ref, 4 * value'length, value);
  end;

  procedure deallocate (
    ptr : inout ext_ptr_t
  ) is begin
    vhpi_ptr_deallocate(ptr.ref);
    ptr := null_ext_ptr;
  end;

  impure function find (
    name : string
  ) return ext_ptr_t is
    variable ref : index_t;
  begin
    ref := vhpi_ptr_find(name);
    if ref < 0 then
      assert false
      report "no ext_ptr found with name " & name
      severity failure;
    end if;
    return (ref => ref);
  end;

  impure function name (
    ptr : ext_ptr_t
  ) return string is
  begin
    return vhpi_ptr_name(ptr.ref);
  end;

  impure function size (
    ptr : ext_ptr_t
  ) return positive is begin
    return vhpi_ptr_size(ptr.ref);
  end;

  impure function access_view (
    ptr : ext_ptr_t
  ) return line is
  begin
    return vhpi_ptr_view_str(ptr.ref);
  end;

  impure function access_view (
    ptr : ext_ptr_t
  ) return integer_vector_access_t is
  begin
    return vhpi_ptr_view_int(ptr.ref);
  end;

  procedure resize (
    ptr  : ext_ptr_t;
    size : positive
  ) is
  begin
    vhpi_ptr_resize(ptr.ref, size);
  end;

  procedure resize (
    ptr    : ext_ptr_t;
    length : positive;
    value  : character := character'low;
    drop   : natural := 0;
    rotate : natural := 0
  ) is
  begin
    assert drop = 0 or rotate = 0 report "can't combine drop and rotate";
    vhpi_ptr_resize_char(ptr.ref, length, value, drop, rotate);
  end;

  procedure resize (
    ptr    : ext_ptr_t;
    length : positive;
    value  : integer := 0;
    drop   : natural := 0;
    rotate : natural := 0
  ) is
  begin
    assert drop = 0 or rotate = 0 report "can't combine drop and rotate";
    vhpi_ptr_resize_int(ptr.ref, length, value, drop, rotate);
  end;

  impure function copy (
    ptr  : ext_ptr_t;
    name : string := ""
  ) return ext_ptr_t is
    constant c_name : string := name & character'val(0);
  begin
    return (ref => vhpi_ptr_copy(ptr.ref, c_name));
  end;

  impure function get_char (
    ptr   : ext_ptr_t;
    index : natural
  ) return character is begin
    return vhpi_ptr_get_char(ptr.ref, index);
  end;

  procedure set_char (
    ptr   : ext_ptr_t;
    index : natural;
    value : character
  ) is begin
    vhpi_ptr_set_char(ptr.ref, index, value);
  end;

  impure function get_int (
    ptr   : ext_ptr_t;
    index : natural
  ) return integer is begin
    return vhpi_ptr_get_int(ptr.ref, index);
  end;

  procedure set_int (
    ptr   : ext_ptr_t;
    index : natural;
    value : integer
  ) is begin
    vhpi_ptr_set_int(ptr.ref, index, value);
  end;

  -----------------------------------------------------------------------------
  -- VHPIDIRECT functions
  -----------------------------------------------------------------------------
  impure function vhpi_ptr_new_str (
    length : positive;
    value  : string;
    name   : string
  ) return index_t is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  impure function vhpi_ptr_new_int (
    length : positive;
    value  : integer_vector_t;
    name   : string
  ) return index_t is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  procedure vhpi_ptr_reallocate_str (
    ref    : index_t;
    length : positive;
    value  : string
  ) is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  procedure vhpi_ptr_reallocate_int (
    ref    : index_t;
    length : positive;
    value  : integer_vector_t
  ) is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  procedure vhpi_ptr_deallocate (
    ref : index_t
  ) is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  impure function vhpi_ptr_find (
    name : string
  ) return index_t is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  impure function vhpi_ptr_name (
    ref : index_t
  ) return string is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  impure function vhpi_ptr_size (
    ref : index_t
  ) return positive is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  impure function vhpi_ptr_view_str (
    ref : index_t
  ) return line is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  impure function vhpi_ptr_view_int (
    ref : index_t
  ) return integer_vector_access_t is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  procedure vhpi_ptr_resize (
    ref  : index_t;
    size : positive
  ) is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  procedure vhpi_ptr_resize_char (
    ref    : index_t;
    length : positive;
    value  : character;
    drop   : natural := 0;
    rotate : natural := 0
  ) is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  procedure vhpi_ptr_resize_int (
    ref    : index_t;
    length : positive;
    value  : integer;
    drop   : natural := 0;
    rotate : natural := 0
  ) is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  impure function vhpi_ptr_copy (
    ref  : index_t;
    name : string
  ) return index_t is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  impure function vhpi_ptr_get_char (
    ref   : index_t;
    index : natural
  ) return character is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  procedure vhpi_ptr_set_char (
    ref   : index_t;
    index : natural;
    value : character
  ) is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  impure function vhpi_ptr_get_int (
    ref   : index_t;
    index : natural
  ) return integer is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

  procedure vhpi_ptr_set_int (
    ref   : index_t;
    index : natural;
    value : integer
  ) is begin
    assert false report "called VHPIDIRECT function" severity failure;
  end;

end package body;

