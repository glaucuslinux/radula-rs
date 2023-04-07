# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    os,
    sequtils,
    strformat,
    strutils,
    tables,
    terminal
]

import constants

import parsetoml

# Returns the full path to the `ceras` file
proc radula_behave_ceras_path_ceras*(name: string): string =
    joinPath(RADULA_PATH_RADULA_CLUSTERS, RADULA_DIRECTORY_GLAUCUS, name, RADULA_CERAS)

# Returns the full path to the `ceras` source directory
proc radula_behave_ceras_path_source*(name: string): string =
    joinPath(RADULA_PATH_RADULA_SOURCES, name)

# Checks if the full path to the `ceras` file exists
proc radula_behave_ceras_exist*(name: string): bool =
    fileExists(radula_behave_ceras_path_ceras(name))

proc radula_behave_ceras_parse*(name: string): TomlValueRef =
    parseFile(radula_behave_ceras_path_ceras(name))

# Resolve concentrates using topological sorting
proc radula_behave_ceras_concentrates_resolve*(name: string,
        concentrates: var Table[string, seq[string]]) =
    concentrates[name] =
        try:
            radula_behave_ceras_parse(name)["cnt"].getStr().split()
        except CatchableError:
            @[]

    if concentrates[name].len() > 0:
        for concentrate in concentrates[name]:
            radula_behave_ceras_concentrates_resolve(concentrate, concentrates)

proc radula_behave_ceras_print*(names: seq[string]) =
    for name in names.deduplicate():
        if not radula_behave_ceras_exist(name):
            stdout.styledWriteLine(fgRed, styleBright,
                &"       abort  :! {name:48}invalid name", resetStyle)
            quit(1)

        let ceras = radula_behave_ceras_parse(name)
        echo "Name          :: ", ceras["nom"].getStr()

        echo "Version       :: ",
            try:
                ceras["ver"].getStr()
            except CatchableError:
                "None",

            try:
                " " & ceras["cmt"].getStr()
            except CatchableError:
                ""

        echo "URL           :: ",
            try:
                ceras["url"].getStr()
            except CatchableError:
                "None"
        echo "Checksum      :: ",
            try:
                ceras["sum"].getStr()
            except CatchableError:
                "None"
        echo "Concentrates  :: ",
            try:
                ceras["cnt"].getStr()
            except CatchableError:
                "None"
        echo "Cysts         :: ",
            try:
                ceras["cys"].getStr()
            except CatchableError:
                "None"
        echo ""
