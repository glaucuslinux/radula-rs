# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

type
  radArch* = enum
    glaucus
    tupleCross = "-glaucus-linux-musl"
    tupleNative = "-pc-linux-musl"
    x86_64 = "x86-64"
    x86_64Linux = "x86_64"
    x86_64_v3 = "x86-64-v3"

  radCerata* = enum
    acl
    attr
    autoconf
    automake
    bash
    binutils
    bison
    bzip2
    cerata
    cmake
    curl
    dash
    eiwd
    execline
    expat
    file
    flex
    fping
    fs
    gcc
    gettextTiny = "gettext-tiny"
    gmp
    gperf
    grep
    hwdata
    iproute2
    isl
    kmod
    less
    libarchive
    libcap
    libedit
    libgcc
    libressl
    libstdcxxV3 = "libstdc++-v3"
    libudevZero = "libudev-zero"
    linux
    linuxCachyOS = "linux-cachyos"
    linuxHeaders = "linux-headers"
    lz4
    m4
    make
    mawk
    mdevd
    mimalloc
    mpc
    mpfr
    musl
    muslHeaders = "musl-headers"
    muslUtils = "musl-utils"
    neatvi
    netbsdCurses = "netbsd-curses"
    openresolv
    pciutils
    pcre2
    perl
    pigz
    pkgconf
    rad
    s6
    s6BootScripts = "s6-boot-scripts"
    s6LinuxInit = "s6-linux-init"
    s6Rc = "s6-rc"
    samurai
    sdhcp
    shadow
    skalibs
    slibtool
    toybox
    utilLinux = "util-linux"
    utmps
    wget2
    xz
    yash
    zlibNg = "zlib-ng"
    zstd

  radDirs* = enum
    log
    pkg
    sac
    src
    tmp

  radEnv* = enum
    # ARCH
    ARCH
    CARCH
    CROSS_COMPILE
    PRETTY_NAME
    BLD
    TGT

    # DIRS
    CERD
    CRSD
    GLAD
    LOGD
    PATH
    PKGD
    SACD
    SRCD
    TMPD
    TLCD

    # FLAGS
    CFLAGS
    CXXFLAGS
    LDFLAGS
    MAKEFLAGS

    # PKG_CONFIG
    PKG_CONFIG_LIBDIR
    PKG_CONFIG_PATH
    PKG_CONFIG_SYSROOT_DIR
    PKG_CONFIG_SYSTEM_INCLUDE_PATH
    PKG_CONFIG_SYSTEM_LIBRARY_PATH

    # TOOLS
    AR
    AS
    AWK
    CC
    CPP
    CXX
    CXXCPP
    HOSTCC
    LEX
    LIBTOOL
    NM
    OBJCOPY
    OBJDUMP
    PKG_CONFIG
    RANLIB
    READELF
    SIZE
    STRIP

  radFiles* = enum
    ceras
    configGuess = "config.guess"
    sum
    tarZst = ".tar.zst"

  radFlags* = enum
    cflags =
      "-pipe -O2 -fgraphite-identity -floop-nest-optimize -flto=auto -flto-compression-level=19 -fuse-linker-plugin -fstack-protector-strong -fstack-clash-protection -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -march=x86-64-v3 -mfpmath=sse -mabi=sysv -malign-data=cacheline -mtls-dialect=gnu2"
    cpp = "-E"
    ldflags =
      "-Wl,-O1,-s,-z,noexecstack,-z,now,-z,pack-relative-relocs,-z,relro,-z,x86-64-v3,--as-needed,--gc-sections,--sort-common,--hash-style=gnu"
    lto = "-flto=auto -flto-compression-level=19 -fuse-linker-plugin "
    make = "-j4 -O"
    parallel = "-j1 -O"
    shellRedirect = "> /dev/null 2>&1"
    zstdCompress = "-22 --ultra -T0 --long"
    zstdDecompress = "-d -T0 --long"

  radHelp* = enum
    Rad =
      """
USAGE:
  rad [ OPTION ]

OPTIONS:
  -b, --bootstrap  Bootstrap glaucus
  -c, --cerata     Manage cerata
  -h, --help       Display this help message
  -v, --version    Display current version"""
    Bootstrap =
      """
USAGE:
  rad [ -b | --bootstrap ] [ COMMAND ]

COMMANDS:
  c, clean         Clean cache
  d, distclean     Clean everything
  h, help          Display this help message
  n, native        Bootstrap native glaucus
  t, toolchain     Bootstrap toolchain
  x, cross         Bootstrap cross glaucus"""
    Cerata =
      """
USAGE:
  rad [ -c | --cerata ] [ COMMAND ] [ cerata ]

COMMANDS:
  b, build         Build cerata
  c, clean         Clean cache
  d, distclean     Clean everything
  h, help          Display this help message
  i, install       Install cerata
  l, list          List installed cerata
  p, print         Print cerata information
  r, remove        Remove cerata
  s, search        Search for cerata
  u, upgrade       Upgrade cerata"""
    version =
      """
rad version 0.1.0

Copyright (c) 2018-2025, Firas Khalil Khana
Distributed under the terms of the ISC License"""

  radNop* = enum
    bootstrap
    check
    empty
    lto
    parallel

  radPaths* = enum
    # FILESYSTEM
    bin
    boot
    doc
    etc
    info
    lib
    lib64
    lostFound = "lost+found"
    man
    mnt
    modules
    share
    usr
    Var = "var"
    wtmpd

    # `pkgconf` and `pkg-config` don't respect the provided sysroot (it doesn't get
    # automatically prefixed to PATH and LIBDIR)
    pkgConfigLibdir = "/usr/lib/pkgconfig"
    pkgConfigSystemIncludePath = "/usr/include"
    pkgConfigSystemLibraryPath = "/usr/lib"
    radConf = "/etc/rad.conf"
    radLock = "/tmp/rad.lock"
    radPkgCache = "/var/cache/rad/pkg"
    radSrcCache = "/var/cache/rad/src"
    radClustersCerataLib = "/var/lib/rad/clusters/cerata"
    radPkgLib = "/var/lib/rad/pkg"
    radLog = "/var/log/rad"
    radTmp = "/var/tmp/rad"

  radPrint* = enum
    build
    install
    Nil = "nil"
    prepare
    remove

  radStages* = enum
    cross
    native
    toolchain

  radTools* = enum
    ar = "gcc-ar"
    As = "as"
    cxx = "g++"
    git
    nm = "gcc-nm"
    objcopy
    objdump
    parted
    ranlib = "gcc-ranlib"
    readelf
    sh
    size
    strip
    tar = "bsdtar"
