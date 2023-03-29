# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    asyncdispatch,
    httpclient,
    os,
    sequtils,
    sha1,
    strutils,
    terminal
]

import ceras

import
    parsetoml,
    toposort

# Verify `SHA-1` checksum of source tarball
proc radula_behave_verify*(file: string, checksum: string): bool =
    parseSecureHash(checksum) == secureHashFile(file)

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

        let path = radula_behave_ceras_path_source(name)

        if dirExists(path):
            if version == "git":
                echo "        skip  :| ", name, " swallowed"
                continue
            else:
                if radula_behave_verify(path / lastPathPart(url), ceras[
                        "sum"].getStr()):
                    echo "        skip  :| ", name, " swallowed"
                    continue
                else:
                    stdout.styledWriteLine(fgRed, "       abort  :! ",
                            resetStyle, name, " invalid ceras checksum")
                    quit(1)

        else:
            if version == "git":
                clones &= @[name, ceras["cmt"].getStr(), url]
            else:
                stdout.styledWriteLine(fgBlue, "     swallow  :@ ", resetStyle,
                    name, " ", version)

                createDir(path)

                downloads &= (@[name, url, ceras["sum"].getStr()],
                    newAsyncHttpClient().downloadFile(url, path / lastPathPart(url)))

    waitFor all(downloads.unzip()[1])

    # use startprocesses for starting multiple git clones as well
    # loop over swallowed cerata and check if they are valid (checksums
