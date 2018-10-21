-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2018, Lars Asplund lars.anders.asplund@gmail.com

-- Stream master verification component interface

library ieee;
use ieee.std_logic_1164.all;

context work.vunit_context;
context work.com_context;
use work.sync_pkg.all;

package stream_pkg is
  -- Stream master handle
  type stream_master_t is record
    p_actor : actor_t;
  end record;

  -- Create a new stream master object
  impure function new_stream_master return stream_master_t;

  -- Stream slave handle
  type stream_slave_t is record
    p_actor : actor_t;
  end record;

  -- Create a new stream slave object
  impure function new_stream_slave return stream_slave_t;

  -- Encapsulate a stream transaction
  type stream_transaction_t is record
    data : std_ulogic_vector;
    last : boolean;
  end record;

  --
  procedure push(msg : msg_t; transaction : stream_transaction_t);

  --
  impure function pop(msg : msg_t) return stream_transaction_t;

  --
  alias push_stream_transaction is push[msg_t, stream_transaction_t];
  alias pop_stream_transaction is pop[msg_t return stream_transaction_t];

  -- Message type definitions used by VC implementing stream VCI
  constant stream_push_msg : msg_type_t := new_msg_type("stream push");
  constant stream_pop_msg : msg_type_t := new_msg_type("stream pop");

  -- Reference to future stream result
  alias stream_reference_t is msg_t;

  -- Push a data value to the stream
  procedure push_stream(signal net : inout network_t;
                        stream : stream_master_t;
                        transaction : stream_transaction_t);

  procedure push_stream(signal net : inout network_t;
                        stream : stream_master_t;
                        data : std_logic_vector;
                        last : boolean := false);

  -- Blocking: pop a value from the stream
  procedure pop_stream(signal net : inout network_t;
                       stream : stream_slave_t;
                       variable transaction : out stream_transaction_t);

  procedure pop_stream(signal net : inout network_t;
                       stream : stream_slave_t;
                       variable data : out std_logic_vector;
                       variable last : out boolean);

  procedure pop_stream(signal net : inout network_t;
                       stream : stream_slave_t;
                       variable data : out std_logic_vector);

  -- Non-blocking: pop a value from the stream to be read in the future
  procedure pop_stream(signal net : inout network_t;
                       stream : stream_slave_t;
                       variable reference : inout stream_reference_t);

  -- Blocking: Wait for reply to non-blocking pop
  procedure await_pop_stream_reply(signal net : inout network_t;
                                   variable reference : inout stream_reference_t;
                                   variable transaction : out stream_transaction_t);

  procedure await_pop_stream_reply(signal net : inout network_t;
                                   variable reference : inout stream_reference_t;
                                   variable data : out std_logic_vector;
                                   variable last : out boolean);

  procedure await_pop_stream_reply(signal net : inout network_t;
                                   variable reference : inout stream_reference_t;
                                   variable data : out std_logic_vector);

  -- Blocking: read stream and check result against expected value
  procedure check_stream(signal net : inout network_t;
                         stream : stream_slave_t;
                         expected : stream_transaction_t;
                         msg : string := "");

  procedure check_stream(signal net : inout network_t;
                         stream : stream_slave_t;
                         expected_data : std_logic_vector;
                         expected_last : boolean := false;
                         msg : string := "");

  -- 
  procedure receive_stream(signal net : inout network_t;
                           stream : stream_master_t;
                           variable transaction : out stream_transaction_t);

  procedure receive_stream(signal net : inout network_t;
                           stream : stream_master_t;
                           variable data : out std_ulogic_vector;
                           variable last : out boolean);

  procedure receive_stream(signal net : inout network_t;
                           stream : stream_master_t;
                           variable data : out std_ulogic_vector);

  -- 
  procedure receive_stream(signal net : inout network_t;
                           stream : stream_slave_t;
                           variable msg : out msg_t);

  -- 
  procedure reply_stream(signal net : inout network_t;
                         variable msg : inout msg_t;
                         transaction : stream_transaction_t);

  procedure reply_stream(signal net : inout network_t;
                         variable msg : inout msg_t;
                         data : std_ulogic_vector;
                         last : boolean);

  procedure reply_stream(signal net : inout network_t;
                         variable msg : inout msg_t;
                         data : std_ulogic_vector);

end package;

package body stream_pkg is
  impure function new_stream_master return stream_master_t is
  begin
    return (p_actor => new_actor);
  end;

  impure function new_stream_slave return stream_slave_t is
  begin
    return (p_actor => new_actor);
  end;

  procedure push(msg : msg_t; transaction : stream_transaction_t) is
  begin
    push_std_ulogic_vector(msg, transaction.data);
    push_boolean(msg, transaction.last);
  end;

  impure function pop(msg : msg_t) return stream_transaction_t is
  begin
    return (data => pop_std_ulogic_vector(msg), last => pop_boolean(msg));
  end;

  procedure push_stream(signal net : inout network_t;
                        stream : stream_master_t;
                        transaction : stream_transaction_t) is
    variable msg : msg_t := new_msg(stream_push_msg);
  begin
    push_stream_transaction(msg, transaction);
    send(net, stream.p_actor, msg);
  end;

  procedure push_stream(signal net : inout network_t;
                        stream : stream_master_t;
                        data : std_logic_vector;
                        last : boolean := false) is
    variable transaction : stream_transaction_t(data(data'range));
  begin
    transaction.data := data;
    transaction.last := last;
    push_stream(net, stream, transaction);
  end;

  procedure pop_stream(signal net : inout network_t;
                       stream : stream_slave_t;
                       variable reference : inout stream_reference_t) is
  begin
    reference := new_msg(stream_pop_msg);
    send(net, stream.p_actor, reference);
  end;

  procedure await_pop_stream_reply(signal net : inout network_t;
                                   variable reference : inout stream_reference_t;
                                   variable transaction : out stream_transaction_t) is
    variable reply_msg : msg_t;
  begin
    receive_reply(net, reference, reply_msg);
    transaction := pop_stream_transaction(reply_msg);
    delete(reference);
    delete(reply_msg);
  end;

  procedure await_pop_stream_reply(signal net : inout network_t;
                                   variable reference : inout stream_reference_t;
                                   variable data : out std_logic_vector;
                                   variable last : out boolean) is
    variable transaction : stream_transaction_t(data(data'range));
  begin
    await_pop_stream_reply(net, reference, transaction);
    data := transaction.data;
    last := transaction.last;
  end;

  procedure await_pop_stream_reply(signal net : inout network_t;
                                   variable reference : inout stream_reference_t;
                                   variable data : out std_logic_vector) is
    variable transaction : stream_transaction_t(data(data'range));
  begin
    await_pop_stream_reply(net, reference, transaction);
    data := transaction.data;
  end;

  procedure pop_stream(signal net : inout network_t;
                       stream : stream_slave_t;
                       variable transaction : out stream_transaction_t) is
    variable reference : stream_reference_t;
  begin
    pop_stream(net, stream, reference);
    await_pop_stream_reply(net, reference, transaction);
  end;

  procedure pop_stream(signal net : inout network_t;
                       stream : stream_slave_t;
                       variable data : out std_logic_vector;
                       variable last : out boolean) is
    variable reference : stream_reference_t;
  begin
    pop_stream(net, stream, reference);
    await_pop_stream_reply(net, reference, data, last);
  end;

  procedure pop_stream(signal net : inout network_t;
                       stream : stream_slave_t;
                       variable data : out std_logic_vector) is
    variable reference : stream_reference_t;
  begin
    pop_stream(net, stream, reference);
    await_pop_stream_reply(net, reference, data);
  end;

  procedure check_stream(signal net : inout network_t;
                         stream : stream_slave_t;
                         expected : stream_transaction_t;
                         msg : string := "") is
    variable got : stream_transaction_t(data(expected.data'range));
  begin
    pop_stream(net, stream, got);
    check_equal(got.data, expected.data, msg);
    check_equal(got.last, expected.last, msg);
  end;

  procedure check_stream(signal net : inout network_t;
                         stream : stream_slave_t;
                         expected_data : std_logic_vector;
                         expected_last : boolean := false;
                         msg : string := "") is
    variable expected : stream_transaction_t(data(expected_data'range));
  begin
    expected.data := expected_data;
    expected.last := expected_last;
    check_stream(net, stream, expected, msg);
  end;

  procedure receive_stream(signal net : inout network_t;
                           stream : stream_master_t;
                           variable transaction : out stream_transaction_t) is
    variable msg : msg_t;
    variable msg_type : msg_type_t;
  begin
    while true loop
      receive(net, stream.p_actor, msg);
      msg_type := message_type(msg);
      handle_sync_message(net, msg_type, msg);
      if msg_type = stream_push_msg then
        transaction := pop_stream_transaction(msg);
        delete(msg);
        exit;
      else
        unexpected_msg_type(msg_type);
      end if;
    end loop;
  end;

  procedure receive_stream(signal net : inout network_t;
                           stream : stream_master_t;
                           variable data : out std_ulogic_vector;
                           variable last : out boolean) is
    variable transaction : stream_transaction_t(data(data'range));
  begin
    receive_stream(net, stream, transaction);
    data := transaction.data;
    last := transaction.last;
  end;

  procedure receive_stream(signal net : inout network_t;
                           stream : stream_master_t;
                           variable data : out std_ulogic_vector) is
    variable transaction : stream_transaction_t(data(data'range));
  begin
    receive_stream(net, stream, transaction);
    data := transaction.data;
  end;

  procedure receive_stream(signal net : inout network_t;
                           stream : stream_slave_t;
                           variable msg : out msg_t) is
    variable msg_type : msg_type_t;
  begin
    while true loop
      receive(net, stream.p_actor, msg);
      msg_type := message_type(msg);
      handle_sync_message(net, msg_type, msg);
      if msg_type = stream_pop_msg then
        exit;
      else
        unexpected_msg_type(msg_type);
      end if;
    end loop;
  end;

  procedure reply_stream(signal net : inout network_t;
                         variable msg : inout msg_t;
                         transaction : stream_transaction_t) is
    variable reply_msg : msg_t;
  begin
   push_stream_transaction(msg, transaction);
   reply(net, msg, reply_msg);
   delete(reply_msg);
  end;

  procedure reply_stream(signal net : inout network_t;
                         variable msg : inout msg_t;
                         data : std_ulogic_vector;
                         last : boolean) is
    variable transaction : stream_transaction_t(data(data'range));
  begin
    transaction.data := data;
    transaction.last := last;
    reply_stream(net, msg, transaction);
  end;

  procedure reply_stream(signal net : inout network_t;
                         variable msg : inout msg_t;
                         data : std_ulogic_vector) is
    variable transaction : stream_transaction_t(data(data'range));
  begin
    transaction.data := data;
    reply_stream(net, msg, transaction);
  end;

end package body;

