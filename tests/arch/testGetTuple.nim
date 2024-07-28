# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/strutils, ../../src/arch

doAssert getTuple()[0].strip().startsWith("x86_64-pc-linux-")
