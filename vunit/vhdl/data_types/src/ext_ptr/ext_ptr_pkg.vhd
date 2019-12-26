-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

use std.textio.all;

library vunit_lib;
use vunit_lib.types_pkg.all;

package ext_ptr_pkg is

  -----------------------------------------------------------------------------
  -- Type definitions
  -----------------------------------------------------------------------------
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
    size : positive;
    name : string  := ""
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
    ptr  : ext_ptr_t;
    size : positive
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

  impure function name (
    ptr : ext_ptr_t
  ) return string;

  impure function size (
    ptr : ext_ptr_t
  ) return positive;

  impure function access_view (
    ptr : ext_ptr_t
  ) return line;

  impure function access_view (
    ptr : ext_ptr_t
  ) return integer_vector_access_t;

  procedure resize (
    ptr  : ext_ptr_t;
    size : positive
  );

  procedure resize (
    ptr    : ext_ptr_t;
    length : positive;
    value  : character := character'low;
    drop   : natural := 0;
    rotate : natural := 0
  );

  procedure resize (
    ptr    : ext_ptr_t;
    length : positive;
    value  : integer := 0;
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
  impure function vhpi_ptr_new_str (
    length : positive;
    value  : string;
    name   : string
  ) return index_t;

  impure function vhpi_ptr_new_int (
    length : positive;
    value  : integer_vector_t;
    name   : string
  ) return index_t;

  procedure vhpi_ptr_reallocate_str (
    ref    : index_t;
    length : positive;
    value  : string
  );

  procedure vhpi_ptr_reallocate_int (
    ref    : index_t;
    length : positive;
    value  : integer_vector_t
  );

  procedure vhpi_ptr_deallocate (
    ref : index_t
  );

  impure function vhpi_ptr_find (
    name : string
  ) return index_t;

  impure function vhpi_ptr_name (
    ref : index_t
  ) return string;

  impure function vhpi_ptr_size (
    ref : index_t
  ) return positive;

  impure function vhpi_ptr_view_str (
    ref : index_t
  ) return line;

  impure function vhpi_ptr_view_int (
    ref : index_t
  ) return integer_vector_access_t;

  procedure vhpi_ptr_resize (
    ref  : index_t;
    size : positive
  );

  procedure vhpi_ptr_resize_char (
    ref    : index_t;
    length : positive;
    value  : character;
    drop   : natural := 0;
    rotate : natural := 0
  );

  procedure vhpi_ptr_resize_int (
    ref    : index_t;
    length : positive;
    value  : integer;
    drop   : natural := 0;
    rotate : natural := 0
  );

  impure function vhpi_ptr_copy (
    ref  : index_t;
    name : string
  ) return index_t;

  impure function vhpi_ptr_get_char (
    ref   : index_t;
    index : natural
  ) return character;

  procedure vhpi_ptr_set_char (
    ref   : index_t;
    index : natural;
    value : character
  );

  impure function vhpi_ptr_get_int (
    ref   : index_t;
    index : natural
  ) return integer;

  procedure vhpi_ptr_set_int (
    ref   : index_t;
    index : natural;
    value : integer
  );

  attribute foreign of vhpi_ptr_new_str        : function  is "VHPIDIRECT vhpi_ptr_new";
  attribute foreign of vhpi_ptr_new_int        : function  is "VHPIDIRECT vhpi_ptr_new";
  attribute foreign of vhpi_ptr_reallocate_str : procedure is "VHPIDIRECT vhpi_ptr_reallocate";
  attribute foreign of vhpi_ptr_reallocate_int : procedure is "VHPIDIRECT vhpi_ptr_reallocate";
  attribute foreign of vhpi_ptr_deallocate     : procedure is "VHPIDIRECT vhpi_ptr_deallocate";
  attribute foreign of vhpi_ptr_find           : function  is "VHPIDIRECT vhpi_ptr_find";
  attribute foreign of vhpi_ptr_name           : function  is "VHPIDIRECT vhpi_ptr_name";
  attribute foreign of vhpi_ptr_size           : function  is "VHPIDIRECT vhpi_ptr_size";
  attribute foreign of vhpi_ptr_view_str       : function  is "VHPIDIRECT vhpi_ptr_view_str";
  attribute foreign of vhpi_ptr_view_int       : function  is "VHPIDIRECT vhpi_ptr_view_int";
  attribute foreign of vhpi_ptr_resize         : procedure is "VHPIDIRECT vhpi_ptr_resize";
  attribute foreign of vhpi_ptr_resize_char    : procedure is "VHPIDIRECT vhpi_ptr_resize_char";
  attribute foreign of vhpi_ptr_resize_int     : procedure is "VHPIDIRECT vhpi_ptr_resize_int";
  attribute foreign of vhpi_ptr_copy           : function  is "VHPIDIRECT vhpi_ptr_copy";
  attribute foreign of vhpi_ptr_get_char       : function  is "VHPIDIRECT vhpi_ptr_get_char";
  attribute foreign of vhpi_ptr_set_char       : procedure is "VHPIDIRECT vhpi_ptr_set_char";
  attribute foreign of vhpi_ptr_get_int        : function  is "VHPIDIRECT vhpi_ptr_get_int";
  attribute foreign of vhpi_ptr_set_int        : procedure is "VHPIDIRECT vhpi_ptr_set_int";

end package;

