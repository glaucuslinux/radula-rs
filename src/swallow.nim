# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import asyncdispatch
import httpclient
import os
import sequtils
import streams
import strutils

import ceras

import hashlib/misc/xxhash
import parsetoml

# Verifies `XXH3_128bits` checksum of source tarball
proc radula_behave_verify*(name: string, file: string, checksum: string): bool =
    checksum == $count[XXHASH3_128](newFileStream(joinPath(
            radula_behave_ceras_path_source(name), file), fmRead))

# Asynchronously swallow cerata
proc radula_behave_swallow*(names: seq[string]) {.async.} =
    var
        clones: seq[string]
        downloads: seq[(seq[string], Future[void])]
        invalid: seq[string]
        swallowed: seq[string]
        virtuals: seq[string]

    for name in names.deduplicate():
        if not radula_behave_ceras_exist(name):
            invalid &= name
            continue

        let
            ceras = radula_behave_ceras_parse(name)

            version = try: ceras["ver"].getStr() except: ""
            url = try: ceras["url"].getStr() except: ""

        if (url == ""):
            virtuals &= name
            continue

        if dirExists(radula_behave_ceras_path_source(name)):
            swallowed &= name
            continue
        else:
            if version == "git":
                clones &= @[name, ceras["cmt"].getStr(), url]
            else:
                echo "    swallow  :< " & (name & " " & version).strip()

                downloads &= (@[name, url, ceras["sum"].getStr()],
                        newAsyncHttpClient().downloadFile(url, lastPathPart(url)))

    waitFor all(downloads.unzip()[1])
    # use startprocesses for starting multiple git clones as well
    # loop over swallowed cerata and check if they are valid (checksums)
