use work.string_ptr_vector_ptr_pkg.all;

package type_pkg is

  type type_t is record
    p_index : integer range -1 to 254;
  end record;

  impure function new_type (
    constant name : string)
    return type_t;

  constant null_type : type_t := (p_index => -1);

  impure function name (
    constant typ : type_t)
    return string;

  constant vhdl_null                   : type_t := new_type("vhdl_null");
  constant vhdl_boolean                : type_t := new_type("vhdl_boolean");
  constant vhdl_boolean_vector         : type_t := new_type("vhdl_boolean_vector");
  constant vhdl_bit                    : type_t := new_type("vhdl_bit");
  constant vhdl_bit_vector             : type_t := new_type("vhdl_bit_vector");
  constant vhdl_character              : type_t := new_type("vhdl_character");
  constant vhdl_string                 : type_t := new_type("vhdl_string");
  constant vhdl_integer                : type_t := new_type("vhdl_integer");
  constant vhdl_integer_vector         : type_t := new_type("vhdl_integer_vector");
  constant vhdl_real                   : type_t := new_type("vhdl_real");
  constant vhdl_real_vector            : type_t := new_type("vhdl_real_vector");
  constant vhdl_time                   : type_t := new_type("vhdl_time");
  constant vhdl_time_vector            : type_t := new_type("vhdl_time_vector");
  constant vhdl_severity_level         : type_t := new_type("vhdl_severity_level");
  constant vhdl_file_open_status       : type_t := new_type("vhdl_file_open_status");
  constant vhdl_file_open_kind         : type_t := new_type("vhdl_file_open_kind");
  constant ieee_numeric_bit_unsigned   : type_t := new_type("ieee_numeric_bit_unsigned");
  constant ieee_numeric_bit_signed     : type_t := new_type("ieee_numeric_bit_signed");
  constant ieee_complex                : type_t := new_type("ieee_complex");
  constant ieee_complex_polar          : type_t := new_type("ieee_complex_polar");
  constant ieee_std_ulogic             : type_t := new_type("ieee_std_ulogic");
  constant ieee_std_ulogic_vector      : type_t := new_type("ieee_std_ulogic_vector");
  constant ieee_numeric_std_unsigned   : type_t := new_type("ieee_numeric_std_unsigned");
  constant ieee_numeric_std_signed     : type_t := new_type("ieee_numeric_std_signed");
  constant ieee_ufixed                 : type_t := new_type("ieee_ufixed");
  constant ieee_sfixed                 : type_t := new_type("ieee_sfixed");
  constant ieee_float                  : type_t := new_type("ieee_float");
  constant vunit_type                  : type_t := new_type("vunit_type");
  constant vunit_range                 : type_t := new_type("vunit_range");
  constant vunit_byte                  : type_t := new_type("vunit_byte");
  constant vunit_integer_vector_ptr    : type_t := new_type("vunit_integer_vector_ptr");
  constant vunit_string_ptr            : type_t := new_type("vunit_string_ptr");
  constant vunit_string_ptr_vector_ptr : type_t := new_type("vunit_string_ptr_vector_ptr");
  constant vunit_list                  : type_t := new_type("vunit_list");
  constant vunit_dict                  : type_t := new_type("vunit_dict");
  constant vunit_ordered_dict          : type_t := new_type("vunit_ordered_dict");
  constant vunit_queue                 : type_t := new_type("vunit_queue");
  constant vunit_integer_array         : type_t := new_type("vunit_integer_array");

  procedure check_type (
    constant got      : type_t;
    constant expected : type_t);

  function is_custom_type (
    constant typ : type_t)
    return boolean;

  function is_ref_type (
    constant typ : type_t)
    return boolean;

end package;

package body type_pkg is

  type type_storage_t is record
    names : string_ptr_vector_ptr_t;
  end record;

  constant type_storage : type_storage_t := (names => new_string_ptr_vector_ptr);

  impure function new_type (
    constant name : string)
    return type_t
  is
    constant new_index  : natural := length(type_storage.names);
    constant new_length : natural := new_index + 1;
  begin
    resize(type_storage.names, new_length);
    set(type_storage.names, new_index, name);
    return (p_index => new_index);
  end;

  impure function name (
    constant typ : type_t)
    return string
  is
  begin
    assert typ /= null_type report "null_type has no name";
    return get_string(type_storage.names, typ.p_index);
  end;

  procedure check_type (
    constant got      : type_t;
    constant expected : type_t)
  is
  begin
    assert got = expected
    report "Got type " & name(got) & ", expected " & name(expected);
  end;

  function is_custom_type (
    constant typ : type_t)
    return boolean
  is
  begin
    return typ.p_index > vunit_integer_array.p_index;
  end;

  function is_ref_type (
    constant typ : type_t)
    return boolean
  is
  begin
    if typ = vunit_integer_vector_ptr
    or typ = vunit_string_ptr
    or typ = vunit_string_ptr_vector_ptr
    or typ = vunit_list
    or typ = vunit_dict
    or typ = vunit_ordered_dict
    or typ = vunit_queue
    or typ = vunit_integer_array
    then
      return true;
    else
      return false;
    end if;
  end;

end package body;

