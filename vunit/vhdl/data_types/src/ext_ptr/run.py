#!/usr/bin/env python3

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2014-2019, Lars Asplund lars.anders.asplund@gmail.com

from vunit import VUnit
from os import popen
from os.path import join, dirname

path = dirname(__file__)

# Compile C code
print(popen("gcc -c ghdl_types.c -o ghdl_types.o").read())
print(popen("gcc -c ext_ptr.c -o ext_ptr.o").read())
print(popen("gcc -c tb_ext_ptr.c -o tb_ext_ptr.o").read())

vu = VUnit.from_argv(vhdl_standard="2008")
vu.enable_location_preprocessing()

lib = vu.add_library("lib")
lib.add_source_files("*.vhd")

# Add C objects to GHDL elaboration
vu.set_sim_option(
    "ghdl.elab_flags",
    [
        "-Wl,ghdl_types.o",
        "-Wl,ext_ptr.o",
        "-Wl,tb_ext_ptr.o",
        "-Wl,-Wl,--version-script=grt.ver"
    ],
)

vu.main()

