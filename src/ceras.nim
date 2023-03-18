# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os
import strutils
import tables

import constants

import parsetoml

# Returns the full path to the `ceras` file
proc radula_behave_ceras_path_ceras*(name: string): string =
    joinPath(RADULA_PATH_RADULA_CLUSTERS, RADULA_DIRECTORY_GLAUCUS, name, RADULA_CERAS)

# Returns the full path to the `ceras` source directory
proc radula_behave_ceras_path_source*(name: string): string =
    joinPath(RADULA_PATH_RADULA_SOURCES, name)

proc radula_behave_ceras_parse*(name: string): TomlValueRef =
    parseFile(radula_behave_ceras_path_ceras(name))

proc radula_behave_ceras_print*(names: seq[string]) =
    for name in names:
        let ceras = radula_behave_ceras_parse(name)
        echo "Name          :: ", ceras["nom"].getStr()
        echo "Version       :: ", try: ceras["ver"].getStr() except: "None",
                try: " " & ceras["cmt"].getStr() except: ""
        echo "URL           :: ", try: ceras["url"].getStr() except: "None"
        echo "Checksum      :: ", try: ceras["sum"].getStr() except: "None"
        echo "Concentrates  :: ", try: ceras["cnt"].getStr() except: "None"
        echo "Cysts         :: ", try: ceras["cys"].getStr() except: "None"
        echo ""

# Resolve dependencies using topological sorting
proc radula_behave_ceras_resolve*(name: string, table: var Table[string, seq[
        string]]) =
    let ceras = radula_behave_ceras_parse(name)
    let name = ceras["nom"].getStr()
    let concentrates = try: ceras["cnt"].getStr().split() except: @[]
    table[name] = concentrates
    if table[name].len > 0:
        for dep in concentrates:
            radula_behave_ceras_resolve(dep, table)
