# Package

version       = "0.1.0"
author        = "Firas Khalil Khana <firasuke@glaucuslinux.org>"
description   = "glaucus's radula"
license       = "ISC"
srcDir        = "src"
bin           = @["radula"]


# Dependencies

requires "hashlib >= 1.0.1"
requires "nim >= 1.6.10"
requires "parsetoml >= 0.7.0"
requires "toposort >= 1.0.0"
