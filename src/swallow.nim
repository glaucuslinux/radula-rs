# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import asyncdispatch
import httpclient
import os
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
        downloads: seq[Future[void]]

    for name in names:
        let
            ceras = radula_behave_ceras_parse(name)

            version = try: ceras["ver"].getStr() except: ""
            url = try: ceras["url"].getStr() except: ""

        if dirExists(radula_behave_ceras_path_source(name)):
            if not (version == "git"):
                let checksum = try: ceras["sum"].getStr() except: ""
                if radula_behave_verify(name, lastPathPart(url), checksum):
                    continue
        else:
            if version == "git":
                clones &= name
            else:
                echo "    swallow  :< " & (name & " " & version).strip()

                downloads &= newAsyncHttpClient().downloadFile(url,
                    lastPathPart(url))

    await all(downloads)
    # use startprocesses for starting multiple git clones as well

    for name in names:
        let
            ceras = radula_behave_ceras_parse(name)

            url = try: ceras["url"].getStr() except: ""
            checksum = try: ceras["url"].getStr() except: ""

            file = radula_behave_ceras_path_source(name) / lastPathPart(url)
