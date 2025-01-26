version = "0.1.0"
author = "Firas Khalil Khana <firasuke@glaucuslinux.org>"
description = "glaucus package manager"
license = "ISC"

skipFiles = @["LICENSE", "README.md"]
srcDir = "src"

bin = @["rad"]

requires "nim >= 2.3.1"
requires "tomlSerialization >= 0.2.14"
requires "toposort >= 1.0.0"
