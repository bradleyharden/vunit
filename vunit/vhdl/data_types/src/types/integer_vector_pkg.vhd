-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

package integer_vector_pkg is
  type integer_vector_t is array (natural range <>) of integer;
  type integer_vector_access_t is access integer_vector_t;
  type integer_vector_access_vector_t is array (natural range <>) of integer_vector_access_t;
  type integer_vector_access_vector_access_t is access integer_vector_access_vector_t;
end package;
