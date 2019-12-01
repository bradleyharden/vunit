-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

-- NOTE: This file is expected to be used along with foreign languages (C)
-- through VHPIDIRECT: https://ghdl.readthedocs.io/en/latest/using/Foreign.html
-- See main.c for an example of a wrapper application.

library vunit_lib;
use vunit_lib.run_pkg.all;
use vunit_lib.logger_pkg.all;
use vunit_lib.check_pkg.all;
use vunit_lib.print_pkg.all;

use work.ext_com_pkg.all;

entity tb_ext_com is
  generic ( runner_cfg : string );
end entity;

architecture tb of tb_ext_com is

begin

  main: process
    variable item : actor_item_ptr_t;
    variable envelope : envelope_ptr_t;
  begin
    test_runner_setup(runner, runner_cfg);

    item := find_actor_item("external actor");
    print(integer'image(item.actor.id));
    print(integer'image(item.inbox.size));
    print(integer'image(item.outbox.size));
    print(item.name.all);

    item := find_actor_item("Full sentence name");
    print(integer'image(item.actor.id));
    print(integer'image(item.inbox.size));
    print(integer'image(item.outbox.size));
    print(item.name.all);

    envelope := pop_envelope(item.actor);
    print(integer'image(envelope.msg.id));
    print(integer'image(envelope.msg.data.meta));
    print(integer'image(envelope.msg.data.data));

    test_runner_cleanup(runner);
  end process;

end architecture;

