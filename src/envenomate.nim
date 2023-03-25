# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import asyncdispatch
import os
import osproc
import strtabs
import strutils
import terminal

import ceras
import constants
import swallow

import parsetoml

#
# Envenomate Function
#

proc radula_behave_envenomate*(names: seq[string], stage: string) =
    # Swallow cerata in parallel
    waitFor radula_behave_swallow(names)

    for name in names:
        let
            ceras = radula_behave_ceras_parse(name)

            version =
                try:
                    ceras["ver"].getStr()
                except CatchableError:
                    ""
            commit =
                try:
                    ceras["cmt"].getStr()
                except CatchableError:
                    ""

        stdout.styledWriteLine(fgGreen, "  envenomate  :~ ", resetStyle, name, " ceras")

        # We only use `nom` and `ver` from the `ceras` file
        discard execProcess(RADULA_CERAS_DASH,
            workingDir = RADULA_DIRECTORY_TEMPORARY, args = [RADULA_TOOTH_SHELL_FLAGS,
            ". " & RADULA_PATH_RADULA_CLUSTERS / RADULA_DIRECTORY_GLAUCUS /
            name / stage &
            " && prepare && configure && build && check && install"],
            env = newStringTable({"nom": name, "ver": version}))
