# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os
import strutils

import ceras
import constants

import parsetoml

#
# Construct Function
#

proc radula_behave_construct*(names: seq[string], stage: string) =
    for name in names:
        # We only require `nom` and `ver` from the `ceras` file
        let ceras = radula_behave_ceras_parse(name)

        let version = try: ceras["ver"].getStr() except: ""
        let commit = try: ceras["cmt"].getStr() except: ""

        echo (name & " " & version & " " & commit).strip()
