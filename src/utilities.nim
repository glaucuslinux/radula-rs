# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    os,
    strformat,
    terminal,
    times
]

import constants

proc radula_exit*(exit_code: int = 0) =
    remove_file(RADULA_FILE_RADULA_LOCK)

    quit(exit_code)

proc radula_behave_abort*() {.noconv.} =
    echo ""

    styled_echo fg_red, style_bright, &"{\"Abort\":13} :! {\"interrupt signal received\":48}{\"1\":13}{now().format(\"hh:mm:ss tt\")}", reset_style

    radula_exit(1)
