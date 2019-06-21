library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package types_pkg is

  type type_t is (
    vhdl_null,
    vhdl_boolean,
    vhdl_boolean_vector,
    vhdl_bit,
    vhdl_bit_vector,
    vhdl_character,
    vhdl_string,
    vhdl_integer,
    vhdl_integer_vector,
    vhdl_real,
    vhdl_real_vector,
    vhdl_time,
    vhdl_time_vector,
    vhdl_severity_level,
    vhdl_file_open_status,
    vhdl_file_open_kind,
    ieee_complex,
    ieee_complex_polar,
    ieee_std_ulogic,
    ieee_std_ulogic_vector,
    ieee_numeric_bit_unsigned,
    ieee_numeric_bit_signed,
    ieee_numeric_std_unsigned,
    ieee_numeric_std_signed,
    ieee_ufixed,
    ieee_sfixed,
    ieee_float,
    vunit_type,
    vunit_range,
    vunit_byte,
    vunit_integer_vector_ptr,
    vunit_string_ptr,
    vunit_queue,
    vunit_integer_array);

  constant null_type : type_t := vhdl_null;

  function is_array_type (
    constant typ : type_t)
    return boolean;

  procedure check_type (
    constant got      : type_t;
    constant expected : type_t);

  function code_length (
    data_type    : type_t;
    array_length : natural := 0)
    return natural;

  type range_t is array (integer range <>) of bit;

  function new_range (
    constant left      : integer := 0;
    constant right     : integer := -1;
    constant ascending : boolean := true)
    return range_t;

  constant null_range : range_t := new_range;

end package;

package body types_pkg is

  function is_array_type (
    constant typ : type_t)
    return boolean
  is
  begin
    if (typ = vhdl_boolean_vector
     or typ = vhdl_bit_vector
     or typ = vhdl_string
     or typ = vhdl_integer_vector
     or typ = vhdl_real_vector
     or typ = vhdl_time_vector
     or typ = ieee_std_ulogic_vector
     or typ = ieee_numeric_bit_unsigned
     or typ = ieee_numeric_bit_signed
     or typ = ieee_numeric_std_unsigned
     or typ = ieee_numeric_std_signed
     or typ = ieee_ufixed
     or typ = ieee_sfixed
     or typ = ieee_float) then
      return true;
    else
      return false;
    end if;
  end;

  function code_length (
    data_type    : type_t;
    array_length : natural := 0)
    return natural
  is
    constant boolean_length   : integer := 1;
    constant integer_length   : integer := 4;
    constant real_length      : integer := boolean_length + 3 * integer_length;
    constant time_length      : integer := 8;
    constant bit_length       : real    := 0.125;
    constant std_logic_length : real    := 0.5;
    constant type_length      : integer := 1;
    constant range_length     : integer := 2 * integer_length + boolean_length;
    constant ptr_length       : integer := integer_length;
  begin
    case data_type is
      when vhdl_null                 => return 0;
      when vhdl_boolean              => return boolean_length;
      when vhdl_boolean_vector       => return array_length * boolean_length;
      when vhdl_bit                  => return integer(ceil(bit_length));
      when vhdl_bit_vector           => return integer(ceil(real(array_length) * bit_length));
      when vhdl_character            => return 1;
      when vhdl_string               => return array_length;
      when vhdl_integer              => return integer_length;
      when vhdl_integer_vector       => return array_length * integer_length;
      when vhdl_real                 => return real_length;
      when vhdl_real_vector          => return array_length * real_length;
      when vhdl_time                 => return time_length;
      when vhdl_time_vector          => return array_length * time_length;
      when vhdl_severity_level       => return 1;
      when vhdl_file_open_status     => return 1;
      when vhdl_file_open_kind       => return 1;
      when ieee_complex              => return 2 * real_length;
      when ieee_complex_polar        => return 2 * real_length;
      when ieee_std_ulogic           => return integer(ceil(std_logic_length));
      when ieee_std_ulogic_vector    => return integer(ceil(real(array_length) * std_logic_length));
      when ieee_numeric_bit_unsigned => return integer(ceil(real(array_length) * bit_length));
      when ieee_numeric_bit_signed   => return integer(ceil(real(array_length) * bit_length));
      when ieee_numeric_std_unsigned => return integer(ceil(real(array_length) * std_logic_length));
      when ieee_numeric_std_signed   => return integer(ceil(real(array_length) * std_logic_length));
      when ieee_ufixed               => return integer(ceil(real(array_length) * std_logic_length));
      when ieee_sfixed               => return integer(ceil(real(array_length) * std_logic_length));
      when ieee_float                => return integer(ceil(real(array_length) * std_logic_length));
      when vunit_type                => return type_length;
      when vunit_range               => return range_length;
      when vunit_byte                => return 1;
      when vunit_integer_vector_ptr  => return ptr_length;
      when vunit_string_ptr          => return ptr_length;
      when vunit_queue               => return 2 * ptr_length;
      when vunit_integer_array       => return 7 * integer_length + boolean_length + ptr_length;
    end case;
  end;

  procedure check_type (
    constant got      : type_t;
    constant expected : type_t)
  is
  begin
    assert got = expected
    report "Got element of type " & type_t'image(got) &
           ", expected " & type_t'image(expected)
    severity error;
  end;

  function new_range (
    constant left      : integer := 0;
    constant right     : integer := -1;
    constant ascending : boolean := true)
    return range_t
  is
    constant ascending_range : range_t(left to right) := (others => '0');
    constant descending_range : range_t(left downto right) := (others => '0');
  begin
    if ascending then
      return ascending_range;
    else
      return descending_range;
    end if;
  end;

end package body;

