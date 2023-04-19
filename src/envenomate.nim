# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    asyncdispatch,
    os,
    osproc,
    sequtils,
    strformat,
    strutils,
    terminal,
    times
]

import
    ceras,
    constants,
    swallow

import
    parsetoml,
    toposort

#
# Envenomate Functions
#

proc radula_behave_stage*(name, version, commit = "", stage: string): (string, int) =
    # We only use `nom` and `ver` from the `ceras`file
    #
    # All phases need to be called sequentially to prevent the loss of the
    # current working directory...
    execCmdEx(RADULA_CERAS_DASH & ' ' & RADULA_TOOTH_SHELL_FLAGS & ' ' & (&"nom={name} ver={version} . {RADULA_PATH_RADULA_CLUSTERS}/{RADULA_DIRECTORY_GLAUCUS}/{name}/{stage} && prepare $1 && configure $1 && build $1 && check $1 && install $1" % [">> log.txt 2>&1"]).quoteShell)

proc radula_behave_envenomate*(names: openArray[string], stage: string = RADULA_DIRECTORY_SYSTEM, resolve: bool = true) =
    var
        log_file: string

        names = names.deduplicate()

        concentrates: Table[string, seq[string]]

        length: int

    for name in names:
        if not radula_behave_ceras_exist(name):
            styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {name:48}{\"nom\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            quit(1)

        if resolve:
            radula_behave_ceras_concentrates_resolve(name, concentrates)

    if resolve:
        names = toposort(concentrates)

    length = names.len()

    echo &"Swallow {length} cerata..."

    radula_behave_ceras_print_header()

    # Swallow cerata in parallel
    waitFor radula_behave_swallow(names)

    echo ""

    echo &"Envenomate {length} cerata..."

    radula_behave_ceras_print_header()

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

        if version == "git":
            styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13} :~ {name:24}{commit:24}{\"phase\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle
        else:
            styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13} :~ {name:24}{version:24}{\"phase\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

        let output = radula_behave_stage(name, version, commit, stage)

        case stage
        of RADULA_DIRECTORY_CROSS:
            log_file = getEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG)
        of RADULA_DIRECTORY_TOOLCHAIN:
            log_file = getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG)

        cursorUp 1
        eraseLine()

        if output[1] != 0:
            styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {name:48}{output[1]:<13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            quit(1)

        if version == "git":
            styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{name:24}", resetStyle, &"{commit:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
        else:
            styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{name:24}", resetStyle, &"{version:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
