# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    os,
    osproc,
    sequtils,
    strformat,
    strutils,
    tables,
    terminal,
    times
]

import constants

import
    hashlib/misc/blake3,
    parsetoml

# Return the full path to the `ceras` file
proc radula_behave_ceras_path_ceras*(nom: string): string =
    RADULA_PATH_RADULA_CLUSTERS / RADULA_DIRECTORY_GLAUCUS / nom / RADULA_FILE_CERAS

# Return the full path to the `ceras` source directory
proc radula_behave_ceras_path_source*(nom: string): string =
    RADULA_PATH_RADULA_SOURCES / nom

# Check if the full path to the `ceras` file exists
proc radula_behave_ceras_exist_ceras*(nom: string): bool =
    fileExists(radula_behave_ceras_path_ceras(nom))

# Parse the `ceras` file
proc radula_behave_ceras_parse_ceras*(nom: string): TomlValueRef =
    parseFile(radula_behave_ceras_path_ceras(nom))

# Checks if the `ceras` source is extracted
proc radula_behave_ceras_extract_source*(file: string): bool =
    for i in walkDir(parentDir(file)):
        if i[1] != file:
            return true
    return false

# Extract the `ceras` source
proc radula_behave_ceras_extract_source*(file, path: string): (string, int) =
    execCmdEx(&"{RADULA_TOOTH_TAR} {RADULA_TOOTH_TAR_EXTRACT_FLAGS} {file} -C {path}")

# Verify the `ceras` source
proc radula_behave_ceras_verify_source*(file, sum: string): bool =
    try:
        $count[BLAKE3](readFile(file)) == sum
    except CatchableError:
        false

# Resolve concentrates using topological sorting
proc radula_behave_ceras_resolve_concentrates*(nom: string, concentrates: var Table[string, seq[string]]) =
    concentrates[nom] =
        try:
            radula_behave_ceras_parse_ceras(nom)["cnt"].getStr().split()
        except CatchableError:
            @[]

    if concentrates[nom].len() > 0:
        for concentrate in concentrates[nom]:
            radula_behave_ceras_resolve_concentrates(concentrate, concentrates)

proc radula_behave_ceras_print*(noms: seq[string]) =
    for nom in noms.deduplicate():
        if not radula_behave_ceras_exist_ceras(nom):
            styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:48}{\"nom\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            quit(QuitFailure)

        let ceras = radula_behave_ceras_parse_ceras(nom)

        styledEcho &"{\"Name\":13} :: ", fgBlue, styleBright, ceras["nom"].getStr(), resetStyle

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

proc radula_behave_ceras_print_header*() =
    echo ""

    styledEcho styleBright, &"{\"Behavior\":13} :: {\"Name\":24}{\"Version\":24}{\"Status\":13}Time", resetStyle
