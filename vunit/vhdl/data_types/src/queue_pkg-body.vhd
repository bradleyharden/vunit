-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

use work.type_pkg.all;
use work.codec_builder_pkg.all;

package body queue_pkg is

  constant tail_idx : natural := 0;
  constant head_idx : natural := 1;
  constant wrap_idx : natural := 2;
  constant num_meta : natural := wrap_idx + 1;

  impure function new_queue
    return queue_t is
  begin
    return (p_meta => new_integer_vector_ptr(length => num_meta),
            data   => new_string_ptr_vector_ptr(length => 256));
  end;

  impure function length (
    queue : queue_t
  ) return natural is
    variable head : natural;
    variable tail : natural;
    variable wrap : natural;
  begin
    assert queue /= null_queue report "Null queue has no length";
    head := get(queue.p_meta, head_idx);
    tail := get(queue.p_meta, tail_idx);
    wrap := get(queue.p_meta, wrap_idx);
    if wrap = 0 then
      return head - tail;
    else
      return length(queue.data) - (head - tail);
    end if;
  end;

  impure function is_empty (
    queue : queue_t
  ) return boolean is begin
    assert queue /= null_queue report "Null queue has no length";
    return length(queue) = 0;
  end;

  impure function is_full (
    queue : queue_t
  ) return boolean is begin
    assert queue /= null_queue report "Null queue has no length";
    return length(queue) = length(queue.data);
  end;

  procedure flush (
    queue : queue_t
  ) is
    variable string_ptr : string_ptr_t;
  begin
    assert queue /= null_queue report "Flush null queue";
    set(queue.p_meta, head_idx, 0);
    set(queue.p_meta, tail_idx, 0);
    set(queue.p_meta, wrap_idx, 0);
    for i in 0 to length(queue.data) - 1 loop
      string_ptr := get(queue.data, i);
      deallocate(string_ptr);
      set(queue.data, i, null_string_ptr);
    end loop;
  end;

  procedure unsafe_push (
    queue : queue_t;
    value : string_ptr_t
  ) is
    variable head : natural;
    variable tail : natural;
    variable wrap : natural;
    variable size : positive;
  begin
    assert queue /= null_queue report "Push to null queue";
    head := get(queue.p_meta, head_idx);
    tail := get(queue.p_meta, tail_idx);
    wrap := get(queue.p_meta, wrap_idx);
    size := length(queue.data);
    if is_full(queue) then
      resize(queue.data, 2 * size, rotate => tail);
      tail := 0;
      head := size;
      wrap := 0;
      size := 2 * size;
      set(queue.p_meta, tail_idx, tail);
      set(queue.p_meta, wrap_idx, wrap);
    end if;
    set(queue.data, head, value);
    head := head + 1;
    if head >= size then
      head := head mod size;
      if wrap = 0 then
        wrap := 1;
      else
        wrap := 0;
      end if;
      set(queue.p_meta, wrap_idx, wrap);
    end if;
    set(queue.p_meta, head_idx, head);
  end;

  impure function unsafe_pop (
    queue : queue_t
  ) return string_ptr_t is
    variable size : positive;
    variable tail : natural;
    variable wrap : natural;
    variable data : string_ptr_t;
  begin
    assert queue /= null_queue report "Pop from null queue";
    assert length(queue) > 0 report "Pop from empty queue";
    size := length(queue.data);
    tail := get(queue.p_meta, tail_idx);
    wrap := get(queue.p_meta, wrap_idx);
    data := get(queue.data, tail);
    set(queue.data, tail, null_string_ptr);
    tail := tail + 1;
    if tail >= size then
      tail := tail mod size;
      if wrap = 0 then
        wrap := 1;
      else
        wrap := 0;
      end if;
      set(queue.p_meta, wrap_idx, wrap);
    end if;
    set(queue.p_meta, tail_idx, tail);
    return data;
  end;

  impure function copy (
    queue : queue_t
  ) return queue_t is
    variable cpy : queue_t;
  begin
    if queue = null_queue then
      return queue;
    else
      cpy.p_meta := copy(queue.p_meta);
      cpy.data := copy(queue.data);
      return cpy;
    end if;
  end;

  procedure deallocate (
    queue : inout queue_t
  ) is begin
    if queue /= null_queue then
      deallocate(queue.p_meta);
      deallocate(queue.data);
      queue := null_queue;
    end if;
  end;

  procedure push_item (
    queue : queue_t;
    value : item_t
  ) is
  begin
    unsafe_push(queue, new_string_ptr(value));
  end;

  impure function pop_item (
    queue : queue_t
  ) return item_t is
    variable ptr  : string_ptr_t := unsafe_pop(queue);
    constant item : item_t := to_string(ptr);
  begin
    deallocate(ptr);
    return item;
  end;

  procedure push (
    queue : queue_t;
    value : boolean
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return boolean is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : bit
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return bit is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : bit_vector
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return bit_vector is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : character
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return character is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : string
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return string is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : integer
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return integer is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : real
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return real is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : time
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return time is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : severity_level
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return severity_level is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : file_open_status
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return file_open_status is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : file_open_kind
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return file_open_kind is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : ieee.numeric_bit.unsigned
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return ieee.numeric_bit.unsigned is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : ieee.numeric_bit.signed
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return ieee.numeric_bit.signed is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : complex
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return complex is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : complex_polar
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return complex_polar is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : std_ulogic
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return std_ulogic is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : std_ulogic_vector
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return std_ulogic_vector is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : ieee.numeric_std.unsigned
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return ieee.numeric_std.unsigned is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : ieee.numeric_std.signed
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return ieee.numeric_std.signed is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : type_t
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return type_t is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : range_t
  ) is begin
    push_item(queue, to_item(value));
  end;

  impure function pop (
    queue : queue_t
  ) return range_t is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push_byte (
    queue : queue_t;
    value : natural range 0 to 255
  ) is begin
    push_item(queue, byte_to_item(value));
  end;

  impure function pop_byte (
    queue : queue_t
  ) return integer is
  begin
    return to_byte(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : inout integer_vector_ptr_t
  ) is begin
    push_item(queue, to_item(value));
    value := null_integer_vector_ptr;
  end;

  impure function pop (
    queue : queue_t
  ) return integer_vector_ptr_t is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : inout string_ptr_t
  ) is begin
    push_item(queue, to_item(value));
    value := null_string_ptr;
  end;

  impure function pop (
    queue : queue_t
  ) return string_ptr_t is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : inout string_ptr_vector_ptr_t
  ) is begin
    push_item(queue, to_item(value));
    value := null_string_ptr_vector_ptr;
  end;

  impure function pop (
    queue : queue_t
  ) return string_ptr_vector_ptr_t is
  begin
    return from_item(pop_item(queue));
  end;

  procedure push (
    queue : queue_t;
    value : inout queue_t
  ) is begin
    push_item(queue, to_item(value));
    value := null_queue;
  end;

  impure function pop (
    queue : queue_t
  ) return queue_t is
  begin
    return from_item(pop_item(queue));
  end;

  -----------------------------------------------------------------------------
  -- Codec procedures & functions
  -----------------------------------------------------------------------------
  procedure encode (
    constant data  :       queue_t;
    variable index : inout positive;
    variable code  : inout string)
  is
  begin
    encode(data.p_meta, index, code);
    encode(data.data,   index, code);
  end;

  procedure decode (
    constant code  :       string;
    variable index : inout positive;
    variable data  : out   queue_t
  ) is begin
    decode(code, index, data.p_meta);
    decode(code, index, data.data);
  end;

  function encode (
    constant data : queue_t
  ) return string is
    variable index : positive := 1;
    variable code  : string(1 to code_length(vunit_integer_vector_ptr) +
                                 code_length(vunit_string_ptr_vector_ptr));
  begin
    encode(data, index, code);
    return code;
  end;

  function decode (
    constant code : string
  ) return queue_t is
    variable index : positive := code'left;
    variable data  : queue_t;
  begin
    decode(code, index, data);
    return data;
  end;

  -----------------------------------------------------------------------------
  -- Item type conversion
  -----------------------------------------------------------------------------
  impure function to_item (
    constant value : queue_t
  ) return item_t is begin
    return encode(vunit_queue) & encode(value);
  end;

  impure function from_item (
    constant item : item_t
  ) return queue_t is begin
    return decode(trim_type(item, vunit_queue));
  end;

end package body;

