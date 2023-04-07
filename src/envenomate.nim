# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    asyncdispatch,
    os,
    osproc,
    sequtils,
    strformat,
    strtabs,
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

proc radula_behave_stage*(name, version, stage, function: string) =
    stdout.styledWriteLine(fgGreen, "  envenomate  :~ ", resetStyle,
        styleBright, &"{name:24}", resetStyle, &"{version:24}", fgYellow,
        function, resetStyle)

    sleep 1000
    if not (function == "install"):
        cursorUp 1
    eraseLine()

    # We only use `nom` and `ver` from the `ceras` file
    # let (output, exitCode) = execCmdEx(RADULA_CERAS_DASH & " " &
    #     RADULA_TOOTH_SHELL_FLAGS & " " & (
    #     &"nom={name} ver={version} . {RADULA_PATH_RADULA_CLUSTERS}/{RADULA_DIRECTORY_GLAUCUS}/{name}/{stage} && {function}").quoteShell)
    # echo "exit code is ", exitCode

proc radula_behave_envenomate*(names: seq[string],
    stage: string = RADULA_DIRECTORY_SYSTEM, resolve: bool = true) =
    var
        names = names.deduplicate()

        concentrates: Table[string, seq[string]]

    for name in names:
        if not radula_behave_ceras_exist(name):
            stdout.styledWriteLine(fgRed, styleBright,
                &"       abort  :! {name:48}invalid name", resetStyle)
            quit(1)

        let ceras = radula_behave_ceras_parse(name)

        if resolve:
            radula_behave_ceras_concentrates_resolve(name, concentrates)

    if resolve:
        names = toposort(concentrates)

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

        radula_behave_stage(name, version, stage, "prepare")
        radula_behave_stage(name, version, stage, "configure")
        radula_behave_stage(name, version, stage, "build")
        radula_behave_stage(name, version, stage, "check")
        radula_behave_stage(name, version, stage, "install")

        cursorUp 1
        eraseLine()

        stdout.styledWriteLine(fgGreen, "  envenomate  :~ ", resetStyle,
            styleBright, &"{name:24}", resetStyle, &"{version:24}", fgGreen,
            "complete", resetStyle)
