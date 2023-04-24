# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    os,
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
func radula_behave_ceras_path_ceras*(nom: string): string =
    RADULA_PATH_RADULA_CLUSTERS / RADULA_DIRECTORY_GLAUCUS / nom / RADULA_FILE_CERAS

# Check if the full path to the `ceras` file exists
func radula_behave_ceras_exist_ceras*(nom: string): bool =
    fileExists(radula_behave_ceras_path_ceras(nom))

# Check if the `ceras` source is extracted
proc radula_behave_ceras_extract_source*(file: string): bool =
    for i in walkDir(parentDir(file)):
        if i[1] != file:
            return true
    return false

# Parse the `ceras` file
proc radula_behave_ceras_parse_ceras*(nom: string): TomlValueRef =
    parseFile(radula_behave_ceras_path_ceras(nom))

# Return the full path to the `ceras` source directory
func radula_behave_ceras_path_source*(nom: string): string =
    RADULA_PATH_RADULA_SOURCES / nom

# Resolve concentrates using topological sorting
proc radula_behave_ceras_resolve_concentrates*(nom: string, concentrates: var Table[string, seq[string]]) =
    # Don't use `{}` because we don't want an empty string "" in our Table
    concentrates[nom] = try: radula_behave_ceras_parse_ceras(nom)["cnt"].getStr().split() except CatchableError: @[]

    if concentrates[nom].len() > 0:
        for concentrate in concentrates[nom]:
            radula_behave_ceras_resolve_concentrates(concentrate, concentrates)

# Verify the `ceras` source
proc radula_behave_ceras_verify_source*(file, sum: string): bool =
    $count[BLAKE3](try: readFile(file) except CatchableError: "") == sum

proc radula_behave_ceras_print*(cerata: seq[string]) =
    for nom in cerata.deduplicate():
        if not radula_behave_ceras_exist_ceras(nom):
            styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:48}{\"nom\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            quit(QuitFailure)

        let ceras = radula_behave_ceras_parse_ceras(nom)

        const NONE = ansiForegroundColorCode(fgRed) & "None" & ansiForegroundColorCode(fgDefault)

        styledEcho &"{\"Name\":13} :: ", fgBlue, styleBright, nom, resetStyle
        echo &"{\"Version\":13} :: ", ceras{"cmt"}.getStr(ceras{"ver"}.getStr(NONE))
        echo &"{\"URL\":13} :: ", ceras{"url"}.getStr(NONE)
        echo &"{\"Checksum\":13} :: ", ceras{"sum"}.getStr(NONE)
        echo &"{\"Concentrates\":13} :: ", ceras{"cnt"}.getStr(NONE)
        echo &"{\"Cysts\":13} :: ", ceras{"cys"}.getStr(NONE)

        echo ""

proc radula_behave_ceras_print_header*() =
    echo ""

    styledEcho styleBright, &"{\"Behavior\":13} :: {\"Name\":24}{\"Version\":24}{\"Status\":13}Time", resetStyle
