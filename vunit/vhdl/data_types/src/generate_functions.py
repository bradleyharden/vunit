#!/usr/bin/env python3

vunit_types = ["vhdl_boolean",
               "vhdl_bit",
               "vhdl_bit_vector",
               "vhdl_character",
               "vhdl_string",
               "vhdl_integer",
               "vhdl_real",
               "vhdl_time",
               "vhdl_severity_level",
               "vhdl_file_open_status",
               "vhdl_file_open_kind",
               "ieee_numeric_bit_unsigned",
               "ieee_numeric_bit_signed",
               "ieee_complex",
               "ieee_complex_polar",
               "ieee_std_ulogic",
               "ieee_std_ulogic_vector",
               "ieee_numeric_std_unsigned",
               "ieee_numeric_std_signed",
               "vunit_type",
               "vunit_range",
               "vunit_integer_vector_ptr",
               "vunit_string_ptr",
               "vunit_string_ptr_vector_ptr"]

vunit_types_2008 = ["vhdl_boolean_vector",
                    "vhdl_integer_vector",
                    "vhdl_real_vector",
                    "vhdl_time_vector",
                    "ieee_ufixed",
                    "ieee_sfixed",
                    "ieee_float"]

vhdl_types = ["boolean",
              "bit",
              "bit_vector",
              "character",
              "string",
              "integer",
              "real",
              "time",
              "severity_level",
              "file_open_status",
              "file_open_kind",
              "ieee.numeric_bit.unsigned",
              "ieee.numeric_bit.signed",
              "complex",
              "complex_polar",
              "std_ulogic",
              "std_ulogic_vector",
              "ieee.numeric_std.unsigned",
              "ieee.numeric_std.signed",
              "type_t",
              "range_t",
              "integer_vector_ptr_t",
              "string_ptr_t",
              "string_ptr_vector_ptr_t"]

vhdl_types_2008 = ["boolean_vector",
                   "integer_vector",
                   "real_vector",
                   "time_vector",
                   "ufixed",
                   "sfixed",
                   "float"]

to_item_template = (
"""  impure function to_item (
    constant value : {vhdl_type})
    return item_t;
""")

from_item_template = (
"""  impure function from_item (
    constant item : item_t)
    return {vhdl_type};
""")

item_alias_template = (
"""  alias {vhdl_type}_to_item is to_item[{vhdl_type} return item_t];
  alias to_{vhdl_type} is from_item[item_t return {vhdl_type}];
""")

to_item_body_template = (
"""  impure function to_item (
    constant value : {vhdl_type})
    return item_t
  is
  begin
    return encode({vunit_type}) & encode(value);
  end;

""")

from_item_body_template = (
"""  impure function from_item (
    constant item : item_t)
    return {vhdl_type}
  is
  begin
    return decode(trim_type(item, {vunit_type}));
  end;

""")


push_body_template = (
"""  procedure push (
    queue : queue_t;
    value : {vhdl_type}
  ) is begin
    push_item(queue, to_item(value));
  end;

""")

pop_body_template = (
"""  impure function pop (
    queue : queue_t
  ) return {vhdl_type} is
  begin
    return from_item(pop_item(queue));
  end;

""")




with open("item_declarations", "w") as of:
    for vhdl, vunit in zip(vhdl_types, vunit_types):
        types = {"vhdl_type": vhdl, "vunit_type":vunit}
        of.write(to_item_template.format(**types))
        of.write(from_item_template.format(**types))

with open("item_declarations_2008", "w") as of:
    for vhdl, vunit in zip(vhdl_types_2008, vunit_types_2008):
        types = {"vhdl_type": vhdl, "vunit_type":vunit}
        of.write(to_item_template.format(**types))
        of.write(from_item_template.format(**types))

with open("item_aliases", "w") as of:
    for vhdl, vunit in zip(vhdl_types, vunit_types):
        types = {"vhdl_type": vhdl, "vunit_type":vunit}
        of.write(item_alias_template.format(**types))

with open("item_aliases_2008", "w") as of:
    for vhdl, vunit in zip(vhdl_types_2008, vunit_types_2008):
        types = {"vhdl_type": vhdl, "vunit_type":vunit}
        of.write(item_alias_template.format(**types))

with open("item_bodies", "w") as of:
    for vhdl, vunit in zip(vhdl_types, vunit_types):
        types = {"vhdl_type": vhdl, "vunit_type":vunit}
        of.write(to_item_body_template.format(**types))
        of.write(from_item_body_template.format(**types))

with open("item_bodies_2008", "w") as of:
    for vhdl, vunit in zip(vhdl_types_2008, vunit_types_2008):
        types = {"vhdl_type": vhdl, "vunit_type":vunit}
        of.write(to_item_body_template.format(**types))
        of.write(from_item_body_template.format(**types))

with open("queue_bodies", "w") as of:
    for vhdl, vunit in zip(vhdl_types, vunit_types):
        types = {"vhdl_type": vhdl, "vunit_type":vunit}
        of.write(push_body_template.format(**types))
        of.write(pop_body_template.format(**types))

with open("queue_bodies_2008", "w") as of:
    for vhdl, vunit in zip(vhdl_types_2008, vunit_types_2008):
        types = {"vhdl_type": vhdl, "vunit_type":vunit}
        of.write(push_body_template.format(**types))
        of.write(pop_body_template.format(**types))

