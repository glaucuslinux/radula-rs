# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os
import streams

import hashlib/misc/xxhash

import ceras

# Verifies `XXH3_128bits` checksum of source tarball
proc radula_behave_verify*(name: string, file: string, checksum: string): bool =
    checksum == $count[XXHASH3_128](newFileStream(joinPath(
            radula_behave_ceras_path_source(name), file), fmRead))
