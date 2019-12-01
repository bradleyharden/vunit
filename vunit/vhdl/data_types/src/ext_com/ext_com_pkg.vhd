use std.textio.all;

package ext_com_pkg is

  type actor_t is record
    id : integer;
  end record;

  type queue_t is record
    meta : integer;
    data : integer;
  end record;

  type msg_t is record
    id         : integer;
    msg_type   : integer;
    status     : integer;
    sender     : actor_t;
    receiver   : actor_t;
    request_id : integer;
    data       : queue_t;
  end record;

  type envelope_t;
  type envelope_ptr_t is access envelope_t;

  type envelope_t is record
    msg           : msg_t;
    next_envelope : envelope_ptr_t;
  end record envelope_t;

  type mailbox_t is record
    num_of_messages : natural;
    size            : natural;
    first_envelope  : envelope_ptr_t;
    last_envelope   : envelope_ptr_t;
  end record mailbox_t;
  type mailbox_ptr_t is access mailbox_t;

  type actor_item_t is record
    actor  : actor_t;
    name   : line;
    inbox  : mailbox_ptr_t;
    outbox : mailbox_ptr_t;
  end record actor_item_t;

  type actor_item_ptr_t is access actor_item_t;
  type actor_item_ptr_array_t is array (natural range <>) of actor_item_ptr_t;
  type actor_item_ptr_array_ptr_t is access actor_item_ptr_array_t;

  impure function create_mailbox (
    size : natural := natural'high)
    return mailbox_ptr_t;

  impure function init_actors return actor_item_ptr_array_ptr_t;

  impure function find_actor_item(
    name : string)
    return actor_item_ptr_t;

  impure function pop_envelope(
    actor : actor_t)
    return envelope_ptr_t;

  -----------------------------------------------------------------------------
  -- VHPIDIRECT functions
  -----------------------------------------------------------------------------
  impure function ext_com_num_actors
    return natural;

  impure function ext_com_get_actor_item(
    index : natural)
    return actor_item_ptr_t;

  attribute foreign of ext_com_num_actors : function is "VHPIDIRECT ext_com_num_actors";
  attribute foreign of ext_com_get_actor_item : function is "VHPIDIRECT ext_com_get_actor_item";

end package;


package body ext_com_pkg is

  impure function create_mailbox(
    size : natural := natural'high)
    return mailbox_ptr_t
  is
  begin
    return new mailbox_t'(0, size, null, null);
  end;

  shared variable null_actor_item : actor_item_ptr_t := new actor_item_t'(
    actor  => (id => -1),
    name   => null,
    inbox  => create_mailbox(0),
    outbox => create_mailbox(0)
  );

  impure function init_actors
    return actor_item_ptr_array_ptr_t
  is
    constant num_ext_actors : natural := ext_com_num_actors;
    variable result : actor_item_ptr_array_ptr_t;
  begin
    result    := new actor_item_ptr_array_t(0 to num_ext_actors);
    result(0) := null_actor_item;
    for i in 0 to num_ext_actors - 1 loop
      result(i + 1) := ext_com_get_actor_item(i);
    end loop;
    return result;
  end;

  shared variable actors : actor_item_ptr_array_ptr_t := init_actors;

  impure function find_actor_item(
    name : string)
    return actor_item_ptr_t
  is
    variable item : actor_item_ptr_t := null_actor_item;
  begin
    for i in actors'reverse_range loop
      item := actors(i);
      if item.name /= null then
        exit when item.name.all = name;
      end if;
    end loop;
    return item;
  end;

  impure function pop_envelope(
    actor : actor_t)
    return envelope_ptr_t
  is
    variable envelope : envelope_ptr_t;
    variable mailbox  : mailbox_ptr_t;
  begin
    mailbox  := actors(actor.id).inbox;
    envelope := mailbox.first_envelope;
    mailbox.first_envelope := envelope.next_envelope;
    return envelope;
  end;


  -----------------------------------------------------------------------------
  -- VHPIDIRECT functions
  -----------------------------------------------------------------------------
  impure function ext_com_num_actors
    return natural
  is
  begin
    return 0;
  end;

  impure function ext_com_get_actor_item(
    index : natural)
    return actor_item_ptr_t
  is
  begin
    return null_actor_item;
  end;

end package body;

