-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

-- NOTE: This file is expected to be used along with foreign languages (C)
-- through VHPIDIRECT: https://ghdl.readthedocs.io/en/latest/using/Foreign.html
-- See main.c for an example of a wrapper application.

use std.textio.all;

library vunit_lib;
use vunit_lib.run_pkg.all;
use vunit_lib.logger_pkg.all;
use vunit_lib.check_pkg.all;
use vunit_lib.print_pkg.all;
use vunit_lib.types_pkg.all;

use work.ext_ptr_pkg.all;

entity tb_ext_ptr is
  generic ( runner_cfg : string );
end entity;

architecture tb of tb_ext_ptr is

begin

  main: process
    variable ptr_size : natural;
    variable ref      : index_t;
    variable ptr_1    : ext_ptr_t;
    variable ptr_2    : ext_ptr_t;
    variable str      : string(1 to 12);
    variable ints     : integer_vector_t(0 to 9);
    variable rotate   : integer;
    variable index    : integer;
    variable ptr_line : line;
    variable ptr_iv_access : integer_vector_access_t;
  begin
    test_runner_setup(runner, runner_cfg);

    if run("Get new ext_ptr from size") then

      ptr_size := 12;
      ptr_1 := new_ext_ptr(ptr_size);
      check(ptr_1 /= null_ext_ptr);
      check_equal(size(ptr_1), ptr_size, result("for ext_ptr size"));
      for i in str'range loop
        check(get_char(ptr_1, i - 1) = character'low);
      end loop;

    elsif run("Get new ext_ptr from string") then

      for i in str'range loop
        str(i) := character'val(64 + i);
      end loop;

      ptr_1 := new_ext_ptr(str);
      check(ptr_1 /= null_ext_ptr);
      check_equal(size(ptr_1), str'length, result("for ext_ptr size"));
      for i in str'range loop
        check(get_char(ptr_1, i - 1) = str(i));
      end loop;

    elsif run("Get new ext_ptr from integer_vector") then

      for i in ints'range loop
        ints(i) := i;
      end loop;

      ptr_1 := new_ext_ptr(ints);
      check(ptr_1 /= null_ext_ptr);
      check_equal(size(ptr_1), 4 * ints'length, result("for ext_ptr size"));
      for i in ints'range loop
        check(get_int(ptr_1, i) = ints(i));
      end loop;

    elsif run("Reallocate ext_ptr from size") then

      ptr_size := 12;
      ptr_1 := new_ext_ptr(ptr_size);
      check_equal(size(ptr_1), ptr_size, result("for ext_ptr size"));

      ptr_size := 8;
      reallocate(ptr_1, ptr_size);
      check_equal(size(ptr_1), ptr_size, result("for ext_ptr size"));

    elsif run("Reallocate ext_ptr from string") then

      ptr_size := 8;
      ptr_1 := new_ext_ptr(ptr_size);
      check_equal(size(ptr_1), ptr_size, result("for ext_ptr size"));

      for i in str'range loop
        str(i) := character'val(64 + i);
      end loop;

      reallocate(ptr_1, str);
      check_equal(size(ptr_1), str'length, result("for ext_ptr size"));
      for i in str'range loop
        check(get_char(ptr_1, i - 1) = str(i));
      end loop;

    elsif run("Reallocate ext_ptr from integer_vector") then

      ptr_size := 8;
      ptr_1 := new_ext_ptr(ptr_size);
      check_equal(size(ptr_1), ptr_size, result("for ext_ptr size"));

      for i in ints'range loop
        ints(i) := i;
      end loop;

      reallocate(ptr_1, ints);
      check_equal(size(ptr_1), 4 * ints'length, result("for ext_ptr size"));
      for i in ints'range loop
        check(get_int(ptr_1, i) = ints(i));
      end loop;

    elsif run("Deallocate ext_ptr") then

      ptr_size := 8;
      ptr_1 := new_ext_ptr(ptr_size);
      check_equal(size(ptr_1), ptr_size, result("for ext_ptr size"));

      deallocate(ptr_1);
      check(ptr_1 = null_ext_ptr);

    elsif run("Find ext_ptr by name") then

      ptr_1 := new_ext_ptr(10, "test name");
      ptr_2 := find("test name");
      check(ptr_1.ref >= 0);
      check_equal(ptr_1.ref, ptr_2.ref, result("for ext_ptr ref"));

    elsif run("Get ext_ptr name") then

      ptr_1 := new_ext_ptr(10, "test name");
      check(name(ptr_1) = "test name");

    elsif run("Get string from ext_ptr") then

      for i in str'range loop
        str(i) := character'val(64 + i);
      end loop;

      ptr_1 := new_ext_ptr(str);
      check(to_string(ptr_1) = str);

    elsif run("Get integer_vector from ext_ptr") then

      for i in ints'range loop
        ints(i) := i;
      end loop;

      ptr_1 := new_ext_ptr(ints);
      check(to_integer_vector(ptr_1) = ints);

    elsif run("Resize ext_ptr from size") then

      ptr_size := 10;
      ptr_1 := new_ext_ptr(ptr_size);
      check_equal(size(ptr_1), ptr_size, result("for ext_ptr size"));

      ptr_size := 20;
      resize(ptr_1, size => ptr_size);
      check_equal(size(ptr_1), ptr_size, result("for ext_ptr size"));

    elsif run("Resize ext_ptr with character value") then

      ptr_1 := new_ext_ptr(10);
      check_equal(size(ptr_1), 10, result("for ext_ptr size"));

      resize(ptr_1, length => 20, value => 'A');
      check_equal(size(ptr_1), 20, result("for ext_ptr size"));
      for i in 0 to 9 loop
        check(get_char(ptr_1, i) = character'low);
      end loop;
      for i in 10 to 19 loop
        check(get_char(ptr_1, i) = 'A');
      end loop;

    elsif run("Resize ext_ptr with integer value") then

      ptr_1 := new_ext_ptr(40);
      check_equal(size(ptr_1), 40, result("for ext_ptr size"));

      resize(ptr_1, length => 20, value => 1234);
      check_equal(size(ptr_1), 80, result("for ext_ptr size"));
      for i in 0 to 9 loop
        check(get_int(ptr_1, i) = 0);
      end loop;
      for i in 10 to 19 loop
        check(get_int(ptr_1, i) = 1234);
      end loop;

    elsif run("Resize ext_ptr string with drop") then

      ptr_1 := new_ext_ptr(10);
      check_equal(size(ptr_1), 10, result("for ext_ptr size"));

      resize(ptr_1, length => 20, value => 'A', drop => 5);
      check_equal(size(ptr_1), 20, result("for ext_ptr size"));
      for i in 0 to 4 loop
        check(get_char(ptr_1, i) = character'low);
      end loop;
      for i in 5 to 19 loop
        check(get_char(ptr_1, i) = 'A');
      end loop;

    elsif run("Resize ext_ptr integer_vector with drop") then

      ptr_1 := new_ext_ptr(40);
      check_equal(size(ptr_1), 40, result("for ext_ptr size"));

      resize(ptr_1, length => 20, value => 1234, drop => 5);
      check_equal(size(ptr_1), 80, result("for ext_ptr size"));
      for i in 0 to 4 loop
        check(get_int(ptr_1, i) = 0);
      end loop;
      for i in 5 to 19 loop
        check(get_int(ptr_1, i) = 1234);
      end loop;

    elsif run("Resize ext_ptr string with rotate") then

      for i in str'range loop
        str(i) := character'val(64 + i);
      end loop;

      ptr_1 := new_ext_ptr(str);
      check_equal(size(ptr_1), str'length, result("for ext_ptr size"));

      rotate := str'length / 2;
      resize(ptr_1, length => 2 * str'length, value => 'Z',
             rotate => rotate);
      check_equal(size(ptr_1), 2 * str'length, result("for ext_ptr size"));

      for i in 0 to str'length - 1 loop
        index := (i + rotate) mod str'length;
        check(get_char(ptr_1, i) = str(index + 1));
      end loop;
      for i in str'length to 2 * str'length - 1 loop
        check(get_char(ptr_1, i) = 'Z');
      end loop;

    elsif run("Resize ext_ptr integer_vector with rotate") then

      for i in ints'range loop
        ints(i) := i;
      end loop;

      ptr_1 := new_ext_ptr(ints);
      check_equal(size(ptr_1), 4 * ints'length, result("for ext_ptr size"));

      rotate := ints'length / 2;
      resize(ptr_1, length => 2 * ints'length, value => 1234,
             rotate => rotate);
      check_equal(size(ptr_1), 4 * 2 * ints'length, result("for ext_ptr size"));

      for i in 0 to ints'length - 1 loop
        index := (i + rotate) mod ints'length;
        check(get_int(ptr_1, i) = ints(index));
      end loop;
      for i in ints'length to 2 * ints'length - 1 loop
        check(get_int(ptr_1, i) = 1234);
      end loop;

    elsif run("Copy ext_ptr") then

      for i in str'range loop
        str(i) := character'val(64 + i);
      end loop;

      ptr_1 := new_ext_ptr(str);
      ptr_2 := copy(ptr_1);
      check(ptr_1.ref >= 0);
      check(ptr_2.ref >= 0);
      check(ptr_1.ref /= ptr_2.ref);

      for i in str'range loop
        check(get_char(ptr_1, i - 1) = str(i));
      end loop;

      for i in str'range loop
        check(get_char(ptr_2, i - 1) = str(i));
      end loop;

    elsif run("Write characters then read integers") then

      ptr_1 := new_ext_ptr(str'length);

      ptr_size := str'length / 4;
      for i in 0 to ptr_size - 1 loop
        set_char(ptr_1, 4*i + 0, character'val(i + 1));
        set_char(ptr_1, 4*i + 1, character'val(0));
        set_char(ptr_1, 4*i + 2, character'val(0));
        set_char(ptr_1, 4*i + 3, character'val(0));
      end loop;

      for i in 0 to ptr_size - 1 loop
        check_equal(get_int(ptr_1, i), i + 1, result("for ext_ptr int"));
      end loop;

    elsif run("Reuse ref index") then

      ptr_1 := new_ext_ptr(10);
      ptr_2 := new_ext_ptr(12);

      check(ptr_1.ref /= ptr_2.ref);

      ref := ptr_1.ref;

      deallocate(ptr_1);
      check(ptr_1 = null_ext_ptr);

      ptr_1 := new_ext_ptr(20);
      check_equal(ptr_1.ref, ref, result("for reused ref"));

    elsif run("Read sequence from C") then

      ptr_1 := find("Read sequence from C");

      for i in 0 to size(ptr_1) - 1 loop
        check(get_char(ptr_1, i) = character'val(i));
      end loop;

    elsif run("Write sequence to C") then

      ptr_1 := new_ext_ptr(256, "Write sequence to C");

      for i in 0 to size(ptr_1) - 1 loop
        set_char(ptr_1, i, character'val(i));
      end loop;

    end if;

    test_runner_cleanup(runner);
  end process;

end architecture;

