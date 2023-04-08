# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    asyncdispatch,
    httpclient,
    os,
    sequtils,
    strformat,
    strutils,
    terminal
]

import ceras

import
    hashlib/misc/blake3,
    parsetoml

# Verify `BLAKE3` checksum of source tarball
proc radula_behave_verify*(file: string, checksum: string): bool =
    $count[BLAKE3](readFile(file)) == checksum

# Asynchronously swallow cerata
proc radula_behave_swallow*(names: seq[string]) {.async.} =
    var
        clones: seq[seq[string]]
        downloads: seq[(seq[string], Future[void])]

    for name in names:
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

        if (url.isEmptyOrWhitespace()):
            stdout.styledWriteLine(fgGreen, &"{\"Swallow\":13}", fgDefault,
                " :@ ", fgBlue, styleBright, &"{name:24}", resetStyle,
                &"{\"virtual\":24}", fgGreen, "complete", fgDefault)
            continue

        let path = radula_behave_ceras_path_source(name)

        if dirExists(path):
            if version == "git":
                stdout.styledWriteLine(fgGreen, &"{\"Swallow\":13}", fgDefault,
                    " :@ ", fgBlue, styleBright, &"{name:24}", resetStyle,
                    &"{version:24}", fgGreen, "complete", fgDefault)
                continue
            else:
                stdout.styledWriteLine(fgMagenta, &"{\"Swallow\":13}",
                    fgDefault, " :@ ", fgBlue, styleBright, &"{name:24}",
                    resetStyle, &"{version:24}", fgMagenta, "verify", fgDefault)
                if radula_behave_verify(path / lastPathPart(url), ceras[
                    "sum"].getStr()):
                    cursorUp 1
                    eraseLine()

                    stdout.styledWriteLine(fgGreen, &"{\"Swallow\":13}",
                        fgDefault, " :@ ", fgBlue, styleBright,
                        &"{name:24}", resetStyle, &"{version:24}", fgGreen,
                        "complete", resetStyle)
                    continue
                else:
                    stdout.styledWriteLine(fgRed, styleBright,
                        &"{\"Abort\":13} :! {name:24}{version:24}invalid checksum", resetStyle)
                    quit(1)

        else:
            if version == "git":
                clones &= @[name, ceras["cmt"].getStr(), url]
            else:
                stdout.styledWriteLine(&"{\"Swallow\":13} :@ ", fgBlue,
                    styleBright, &"{name:24}", resetStyle, &"{version:24}",
                    fgMagenta, "fetch", fgDefault)

                createDir(path)

                downloads &= (@[name, url, ceras["sum"].getStr()],
                    newAsyncHttpClient().downloadFile(url, path / lastPathPart(url)))

    waitFor all(downloads.unzip()[1])

    # use startprocesses for starting multiple git clones as well
    # loop over swallowed cerata and check if they are valid (checksums
