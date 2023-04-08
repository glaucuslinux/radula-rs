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
            styledEcho fgRed, styleBright,
                &"{\"Abort\":13} :! {name:48}invalid name", resetStyle
            quit(1)

        let ceras = radula_behave_ceras_parse(name)
        styledEcho &"{\"Name\":13} :: ", fgBlue, styleBright, ceras[
            "nom"].getStr(), resetStyle

        echo &"{\"Version\":13} :: ",
            try:
                ceras["ver"].getStr()
            except CatchableError:
                "None",

            try:
                " " & ceras["cmt"].getStr()
            except CatchableError:
                ""

        echo &"{\"URL\":13} :: ",
            try:
                ceras["url"].getStr()
            except CatchableError:
                "None"
        echo &"{\"Checksum\":13} :: ",
            try:
                ceras["sum"].getStr()
            except CatchableError:
                "None"
        echo &"{\"Concentrates\":13} :: ",
            try:
                ceras["cnt"].getStr()
            except CatchableError:
                "None"
        echo &"{\"Cysts\":13} :: ",
            try:
                ceras["cys"].getStr()
            except CatchableError:
                "None"
        echo ""
