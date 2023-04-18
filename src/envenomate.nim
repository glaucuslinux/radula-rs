# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    asyncdispatch,
    os,
    osproc,
    sequtils,
    strformat,
    terminal
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
    execCmdEx(RADULA_CERAS_DASH & " " & RADULA_TOOTH_SHELL_FLAGS & " " & (
        &"nom={name} ver={version} . {RADULA_PATH_RADULA_CLUSTERS}/{RADULA_DIRECTORY_GLAUCUS}/{name}/{stage} && prepare && configure && build && check && install").quoteShell)

proc radula_behave_envenomate*(names: seq[string],
    stage: string = RADULA_DIRECTORY_SYSTEM, resolve: bool = true) =
    var
        log_file: File

        names = names.deduplicate()

        concentrates: Table[string, seq[string]]

    for name in names:
        if not radula_behave_ceras_exist(name):
            styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {name:48}invalid name", resetStyle

            quit(1)

        if resolve:
            radula_behave_ceras_concentrates_resolve(name, concentrates)

    if resolve:
        names = toposort(concentrates)

    echo &"Swallow {names.len()} cerata..."

    radula_behave_ceras_print_header()

    # Swallow cerata in parallel
    waitFor radula_behave_swallow(names)

    echo ""

    echo &"Envenomate {names.len()} cerata..."

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
            styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, &"{name:24}", fgDefault, &"{commit:24}", fgMagenta, "phase", resetStyle
        else:
            styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, &"{name:24}", fgDefault, &"{version:24}", fgMagenta, "phase", resetStyle

        let output = radula_behave_stage(name, version, commit, stage)

        case stage
        of RADULA_DIRECTORY_CROSS:
            log_file = open(getEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG), fmAppend)
        of RADULA_DIRECTORY_SYSTEM:
            echo "system is not implemented yet..."
        of RADULA_DIRECTORY_TOOLCHAIN:
            log_file = open(getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG), fmAppend)

        log_file.write(output[0])
        log_file.close()

        cursorUp 1
        eraseLine()

        if output[1] != 0:
            styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {name:48}exit {output[1]}", resetStyle

            quit(1)

        if version == "git":
            styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{name:24}", resetStyle, &"{commit:24}", fgGreen, "complete", fgDefault
        else:
            styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{name:24}", resetStyle, &"{version:24}", fgGreen, "complete", fgDefault
