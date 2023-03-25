# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import asyncdispatch
import httpclient
import os
import sequtils
import streams
import strutils
import terminal

import ceras

import hashlib/misc/xxhash
import parsetoml
import toposort

# Verifies `XXH3_128bits` checksum of source tarball
proc radula_behave_verify*(name: string, file: string, checksum: string): bool =
    checksum == $count[XXHASH3_128](newFileStream(joinPath(
            radula_behave_ceras_path_source(name), file), fmRead))

# Asynchronously swallow cerata
proc radula_behave_swallow*(names: seq[string]) {.async.} =
    var
        names = names.deduplicate()

        concentrates: Table[string, seq[string]]

        clones: seq[seq[string]]
        downloads: seq[(seq[string], Future[void])]

    for name in names:
        if not radula_behave_ceras_exist(name):
            stdout.styledWriteLine(fgRed, "       abort  :! ", resetStyle, name, " invalid ceras name")
            quit(1)

        let
            ceras = radula_behave_ceras_parse(name)

            url =
                try:
                    ceras["url"].getStr()
                except CatchableError:
                    ""

        if (url == ""):
            echo "        skip  :| ", name, " virtual"
            continue

        radula_behave_ceras_concentrates_resolve(name, concentrates)

    for name in toposort(concentrates):
        let
            ceras = radula_behave_ceras_parse(name)

            version =
                try:
                    ceras["ver"].getStr()
                except CatchableError:
                    ""
            url =
                try:
                    ceras["url"].getStr()
                except CatchableError:
                    ""

        if (url == ""):
            echo "        skip  :| ", name, " virtual"
            continue

        if dirExists(radula_behave_ceras_path_source(name)):
            echo "        skip  :| ", name, " swallowed"
            continue
        else:
            if version == "git":
                clones &= @[name, ceras["cmt"].getStr(), url]
            else:
                stdout.styledWriteLine(fgBlue, "     swallow  :@ ", resetStyle,
                    name, " ", version)

                downloads &= (@[name, url, ceras["sum"].getStr()],
                    newAsyncHttpClient().downloadFile(url, lastPathPart(url)))

    waitFor all(downloads.unzip()[1])

    # use startprocesses for starting multiple git clones as well
    # loop over swallowed cerata and check if they are valid (checksums
