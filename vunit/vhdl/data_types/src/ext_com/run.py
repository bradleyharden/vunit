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

# Compile C application to an object
print(popen("gcc -c ext_com.c -o ext_com.o").read())
print(popen("gcc -c tb_ext_com.c -o tb_ext_com.o").read())

# Enable the external feature for strings
vu = VUnit.from_argv(vhdl_standard="93")

lib = vu.add_library("lib")
lib.add_source_files("*.vhd")

# Add the C object to the elaboration of GHDL
vu.set_sim_option(
    "ghdl.elab_flags",
    [
        "-Wl,ext_com.o",
        "-Wl,tb_ext_com.o",
        "-Wl,-Wl,--version-script=grt.ver"
    ],
)

vu.main()

