-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

use std.textio.all;

package ext_ptr_pkg is

  -----------------------------------------------------------------------------
  -- Type definitions
  -----------------------------------------------------------------------------
  subtype index_t is integer range -1 to integer'high;

  type integer_vector_t is array (natural range <>) of integer;

  type ext_ptr_t is record
    ref : index_t;
  end record;

  constant null_ext_ptr : ext_ptr_t := (ref => -1);

  function to_integer (
    value : ext_ptr_t
  ) return index_t;

  impure function to_ext_ptr (
    value : index_t
  ) return ext_ptr_t;


  -----------------------------------------------------------------------------
  -- VHDL functions
  -----------------------------------------------------------------------------
  impure function new_ext_ptr (
    length : positive;
    name   : string  := ""
  ) return ext_ptr_t;

  impure function new_ext_ptr (
    value : string;
    name  : string := ""
  ) return ext_ptr_t;

  impure function new_ext_ptr (
    value : integer_vector_t;
    name  : string := ""
  ) return ext_ptr_t;

  procedure reallocate (
    ptr    : ext_ptr_t;
    length : positive
  );

  procedure reallocate (
    ptr   : ext_ptr_t;
    value : string
  );

  procedure reallocate (
    ptr   : ext_ptr_t;
    value : integer_vector_t
  );

  procedure deallocate (
    ptr : inout ext_ptr_t
  );

  impure function find (
    name : string
  ) return ext_ptr_t;

  impure function length (
    ptr : ext_ptr_t
  ) return positive;

  impure function name (
    ptr : ext_ptr_t
  ) return line;

  procedure resize (
    ptr    : ext_ptr_t;
    length : positive;
    drop   : natural := 0;
    rotate : natural := 0
  );

  impure function copy (
    ptr  : ext_ptr_t;
    name : string := ""
  ) return ext_ptr_t;

  impure function get_char (
    ptr   : ext_ptr_t;
    index : natural
  ) return character;

  procedure set_char (
    ptr   : ext_ptr_t;
    index : natural;
    value : character
  );

  impure function get_int (
    ptr   : ext_ptr_t;
    index : natural
  ) return integer;

  procedure set_int (
    ptr   : ext_ptr_t;
    index : natural;
    value : integer
  );


  -----------------------------------------------------------------------------
  -- VHPIDIRECT functions
  -----------------------------------------------------------------------------
  impure function ext_ptr_new_str (
    length : positive;
    value  : string;
    name   : string
  ) return index_t;

  impure function ext_ptr_new_int (
    length : positive;
    value  : integer_vector_t;
    name   : string
  ) return index_t;

  procedure ext_ptr_reallocate_str (
    ref    : index_t;
    length : positive;
    value  : string
  );

  procedure ext_ptr_reallocate_int (
    ref    : index_t;
    length : positive;
    value  : integer_vector_t
  );

  procedure ext_ptr_deallocate (
    ref : index_t
  );

  impure function ext_ptr_find (
    name : string
  ) return index_t;

  impure function ext_ptr_bare_str (
    ref : index_t
  ) return string;

  impure function ext_ptr_bare_int (
    ref : index_t
  ) return integer_vector_t;

  impure function ext_ptr_length (
    ref : index_t
  ) return positive;

  impure function ext_ptr_name (
    ref : index_t
  ) return line;

  procedure ext_ptr_resize (
    ref    : index_t;
    length : positive;
    drop   : natural := 0;
    rotate : natural := 0
  );

  impure function ext_ptr_copy (
    ref  : index_t;
    name : string
  ) return index_t;

  impure function ext_ptr_get_char (
    ref   : index_t;
    index : natural
  ) return character;

  procedure ext_ptr_set_char (
    ref   : index_t;
    index : natural;
    value : character
  );

  impure function ext_ptr_get_int (
    ref   : index_t;
    index : natural
  ) return integer;

  procedure ext_ptr_set_int (
    ref   : index_t;
    index : natural;
    value : integer
  );

  attribute foreign of ext_ptr_new_str        : function  is "VHPIDIRECT ptr_new_vhpi";
  attribute foreign of ext_ptr_new_int        : function  is "VHPIDIRECT ptr_new_vhpi";
  attribute foreign of ext_ptr_reallocate_str : procedure is "VHPIDIRECT ptr_reallocate_vhpi";
  attribute foreign of ext_ptr_reallocate_int : procedure is "VHPIDIRECT ptr_reallocate_vhpi";
  attribute foreign of ext_ptr_deallocate     : procedure is "VHPIDIRECT ptr_deallocate_vhpi";
  attribute foreign of ext_ptr_find           : function  is "VHPIDIRECT ptr_find_vhpi";
  attribute foreign of ext_ptr_bare_str       : function  is "VHPIDIRECT ptr_bare_vhpi";
  attribute foreign of ext_ptr_bare_int       : function  is "VHPIDIRECT ptr_bare_vhpi";
  attribute foreign of ext_ptr_length         : function  is "VHPIDIRECT ptr_length_vhpi";
  attribute foreign of ext_ptr_name           : function  is "VHPIDIRECT ptr_name_vhpi";
  attribute foreign of ext_ptr_resize         : procedure is "VHPIDIRECT ptr_resize_vhpi";
  attribute foreign of ext_ptr_copy           : function  is "VHPIDIRECT ptr_copy_vhpi";
  attribute foreign of ext_ptr_get_char       : function  is "VHPIDIRECT ptr_get_char_vhpi";
  attribute foreign of ext_ptr_set_char       : procedure is "VHPIDIRECT ptr_set_char_vhpi";
  attribute foreign of ext_ptr_get_int        : function  is "VHPIDIRECT ptr_get_int_vhpi";
  attribute foreign of ext_ptr_set_int        : procedure is "VHPIDIRECT ptr_set_int_vhpi";

end package;

