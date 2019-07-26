use work.integer_vector_pkg.all;

package slice_pkg is

  subtype slice_t is integer_vector_t;

  subtype indices_t is integer_vector_t(1 to 3);

  function index (
    index  : integer;
    length : natural;
    check  : boolean := true)
    return integer;

  function indices (
    slice  : integer_vector_t;
    length : natural;
    check  : boolean := true)
    return integer_vector_t;

end package;

package body slice_pkg is

  function normalize (
    value  : integer;
    length : natural;
    check  : boolean;
    up     : boolean)
    return integer
  is
    variable index : integer := value;
  begin
    if index < 0 then
      index := index + length;
    end if;
    if check then
      assert 0 <= index and index < length report "index out of bounds";
    else
      if up then
        if index < 0 then
          index := 0;
        elsif index > length then
          index := length;
        end if;
      else
        if index < -1 then
          index := -1;
        elsif index > length - 1 then
          index := length - 1;
        end if;
      end if;
    end if;
    return index;
  end;

  function index (
    index  : integer;
    length : natural;
    check  : boolean := true)
    return integer
  is
  begin
    return normalize(index, length, check, true);
  end;

  function indices (
    slice  : integer_vector_t;
    length : natural;
    check  : boolean := true)
    return integer_vector_t
  is
    variable indices : indices_t;
    variable j       : integer := 1;
  begin
    assert slice'length = 2 or slice'length = 3 report "invalid slice";
    if slice'length = 2 then
      indices(3) := 1;
    else
      indices(3) := slice(3);
      assert indices(3) /= 0 report "slice step cannot be zero";
    end if;
    for i in slice'range loop
      indices(j) := normalize(slice(i), length, check, indices(3) > 0);
      j := j + 1;
      exit when j = 3;
    end loop;
    return indices;
  end;

end package body;

