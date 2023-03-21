# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import asyncdispatch
import os
import osproc
import strtabs
import strutils

import ceras
import constants
import swallow

import parsetoml

#
# Envenomate Function
#

proc radula_behave_envenomate*(names: seq[string], stage: string) =
    # Download source tarballs in parallel
    # waitFor radula_behave_swallow(names)

    for name in names:
        # We only require `nom` and `ver` from the `ceras` file
        let ceras = radula_behave_ceras_parse(name)

        let version = try: ceras["ver"].getStr() except: ""
        let commit = try: ceras["cmt"].getStr() except: ""

        echo " envenomate  :> " & (name & " " & version & " " & commit).strip()

        echo "testing: ", RADULA_PATH_RADULA_CLUSTERS /
                RADULA_DIRECTORY_GLAUCUS / name / stage
        discard execProcess(RADULA_CERAS_DASH, args = [RADULA_TOOTH_SHELL_FLAGS,
            ". " & RADULA_PATH_RADULA_CLUSTERS / RADULA_DIRECTORY_GLAUCUS /
            name / stage &
            " && prepare && configure && build && check && install"],
            env = newStringTable({"nom": name, "ver": version}))
