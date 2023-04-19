# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import strutils

import ../../src/architecture

doAssert radula_behave_architecture_tuple()[0].strip() == "x86_64-pc-linux-gnu"
