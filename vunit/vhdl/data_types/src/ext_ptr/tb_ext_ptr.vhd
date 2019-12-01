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

use work.ext_ptr_pkg.all;

entity tb_ext_ptr is
  generic ( runner_cfg : string );
end entity;

architecture tb of tb_ext_ptr is

begin

  main: process
    variable len   : natural;
    variable ref   : index_t;
    variable ptr_1 : ext_ptr_t;
    variable ptr_2 : ext_ptr_t;
    variable str   : string(1 to 12);
    variable ints  : integer_vector_t(0 to 9);
  begin
    test_runner_setup(runner, runner_cfg);

    if run("Get new ext_ptr by length") then

      len := 12;
      ptr_1 := new_ext_ptr(len);
      check(ptr_1.ref > -1);
      check_equal(length(ptr_1), len, result("for ext_ptr length"));
      for i in 0 to length(ptr_1) - 1 loop
        check(get_char(ptr_1, i) = character'val(0));
      end loop;

    elsif run("Get new ext_ptr from string") then

      for i in str'range loop
        str(i) := character'val(64 + i);
      end loop;

      ptr_1 := new_ext_ptr(str);
      check_equal(length(ptr_1), str'length, result("for ext_ptr length"));
      for i in str'range loop
        check(get_char(ptr_1, i - 1) = str(i));
      end loop;

    elsif run("Get new ext_ptr from integer vector") then

      for i in ints'range loop
        ints(i) := i;
      end loop;

      ptr_1 := new_ext_ptr(ints);
      check_equal(length(ptr_1), 4 * ints'length, result("for ext_ptr length"));
      for i in ints'range loop
        check(get_int(ptr_1, i) = ints(i));
      end loop;

    elsif run("Reallocate ext_ptr by length") then

      len := 12;
      ptr_1 := new_ext_ptr(len);
      check_equal(length(ptr_1), len, result("for ext_ptr length"));

      len := 8;
      reallocate(ptr_1, len);
      check_equal(length(ptr_1), len, result("for ext_ptr length"));

    elsif run("Reallocate ext_ptr from string") then

      len := 8;
      ptr_1 := new_ext_ptr(len);
      check_equal(length(ptr_1), len, result("for ext_ptr length"));

      for i in str'range loop
        str(i) := character'val(64 + i);
      end loop;

      reallocate(ptr_1, str);
      check_equal(length(ptr_1), str'length, result("for ext_ptr length"));
      for i in str'range loop
        check(get_char(ptr_1, i - 1) = str(i));
      end loop;

    elsif run("Reallocate ext_ptr from integer vector") then

      len := 8;
      ptr_1 := new_ext_ptr(len);
      check_equal(length(ptr_1), len, result("for ext_ptr length"));

      for i in ints'range loop
        ints(i) := i;
      end loop;

      reallocate(ptr_1, ints);
      check_equal(length(ptr_1), 4 * ints'length, result("for ext_ptr length"));
      for i in ints'range loop
        check(get_int(ptr_1, i) = ints(i));
      end loop;

    elsif run("Deallocate ext_ptr") then

      len := 8;
      ptr_1 := new_ext_ptr(len);
      check_equal(length(ptr_1), len, result("for ext_ptr length"));

      deallocate(ptr_1);
      check(ptr_1 = null_ext_ptr);

    elsif run("Find ext_ptr by name") then

      ptr_1 := new_ext_ptr(10, "test name");
      ptr_2 := find("test name");
      check(ptr_1.ref >= 0);
      check_equal(ptr_1.ref, ptr_2.ref, result("for ext_ptr ref"));

    elsif run("Get ext_ptr name") then

      ptr_1 := new_ext_ptr(10, "test name");
      check(name(ptr_1).all = "test name");

    elsif run("Resize ext_ptr") then

      len := 10;
      ptr_1 := new_ext_ptr(len);
      check_equal(length(ptr_1), len, result("for ext_ptr length"));

      len := 20;
      resize(ptr_1, len);
      check_equal(length(ptr_1), len, result("for ext_ptr length"));

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

      len := str'length / 4;
      for i in 0 to len - 1 loop
        set_char(ptr_1, 4*i + 0, character'val(i + 1));
        set_char(ptr_1, 4*i + 1, character'val(0));
        set_char(ptr_1, 4*i + 2, character'val(0));
        set_char(ptr_1, 4*i + 3, character'val(0));
      end loop;

      for i in 0 to len - 1 loop
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

      for i in 0 to length(ptr_1) - 1 loop
        check(get_char(ptr_1, i) = character'val(i));
      end loop;

    end if;

    test_runner_cleanup(runner);
  end process;

end architecture;

