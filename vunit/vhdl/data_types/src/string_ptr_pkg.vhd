-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com
--
-- The purpose of this package is to provide an string access type (pointer)
-- that can itself be used in arrays and returned from functions unlike a
-- real access type. This is achieved by letting the actual value be a handle
-- into a singleton datastructure of string access types.
--

use work.string_pkg.all;

use work.codec_pkg.all;
use work.codec_builder_pkg.all;

package string_ptr_pkg is
  subtype index_t is integer range -1 to integer'high;
  type string_ptr_t is record
    ref : index_t;
  end record;
  constant null_string_ptr : string_ptr_t := (ref => -1);

  alias  ptr_t  is string_ptr_t;
  alias  val_t  is character;
  alias  vav_t  is string_access_vector_t;
  alias  vava_t is string_access_vector_access_t;

  function to_integer (
    value : ptr_t
  ) return integer;

  impure function to_string_ptr (
    value : integer
  ) return ptr_t;

  impure function new_string_ptr (
    length : natural := 0
  ) return ptr_t;

  impure function new_string_ptr (
    value : string
  ) return ptr_t;

  procedure deallocate (
    ptr : ptr_t
  );

  impure function length (
    ptr : ptr_t
  ) return integer;

  procedure set (
    ptr   : ptr_t;
    index : natural;
    value : val_t
  );

  impure function get (
    ptr   : ptr_t;
    index : natural
  ) return val_t;

  procedure reallocate (
    ptr    : ptr_t;
    length : natural
  );

  procedure reallocate (
    ptr   : ptr_t;
    value : string
  );

  procedure resize (
    ptr    : ptr_t;
    length : natural;
    drop   : natural := 0
  );

  impure function to_string (
    ptr : ptr_t
  ) return string;

  function encode (
    data : ptr_t
  ) return string;

  function decode (
    code : string
  ) return ptr_t;

  procedure decode (
    constant code   : string;
    variable index  : inout positive;
    variable result : out ptr_t
  );

  alias encode_ptr_t is encode[ptr_t return string];
  alias decode_ptr_t is decode[string return ptr_t];

  constant string_ptr_t_code_length : positive := integer_code_length;

end package;
