# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

type
  radArch* = enum
    glaucus

    tupleCross = "-glaucus-linux-musl"
    tupleNative = "-pc-linux-musl"

    x86_64 = "x86-64"
    x86_64Linux= "x86_64"
    x86_64_v3 = "x86-64-v3"


  radCerata* = enum
    acl
    attr
    autoconf
    automake

    bash
    binutils
    booster
    byacc
    bzip2

    cerata = "cerata"
    cmake

    diffutils

    e2fsprogs
    execline
    expat

    file
    filesystem
    findutils
    flex

    gcc
    gettextTiny = "gettext-tiny"
    gmp
    grep
    grub

    help2man

    iproute2
    iputils
    isl

    kbd
    kmod

    less
    libarchive
    libcap
    libcapNg = "libcap-ng"
    libedit
    libgcc
    libressl
    libstdcxxV3 = "libstdc++-v3"
    libtool
    libudevZero = "libudev-zero"
    linux
    linuxHeaders = "linux-headers"
    lz4

    m4
    make
    mandoc
    mawk
    mdevd
    mpc
    mpfr
    muon
    musl
    muslFts = "musl-fts"
    muslHeaders = "musl-headers"
    muslUtils = "musl-utils"

    netbsdCurses = "netbsd-curses"
    nsss

    opendoas

    patch
    pcre2
    perl
    pigz
    pkgconf
    procpsNg = "procps-ng"
    psmisc

    rad
    rsync

    s6
    s6BootScripts = "s6-boot-scripts"
    s6LinuxInit = "s6-linux-init"
    s6Rc = "s6-rc"
    samurai
    sdhcp
    sed
    shadow
    skalibs

    texinfo
    toybox
    tzcode
    tzdata

    utilLinux = "util-linux"
    utmps

    vim

    wget2

    xxhash
    xz

    yash

    zlibNg = "zlib-ng"
    zstd


  radDirs* = enum
    bak
    bld
    iso
    log
    sac
    src
    tmp


  radEnv* = enum
    # ARCH
    ARCH
    BOOTSTRAP
    CARCH
    CROSS_COMPILE
    PRETTY_NAME

    BLD
    TGT

    # DIRS
    BAKD
    CERD
    CRSD
    GLAD
    ISOD
    LOGD
    SACD
    SRCD
    TBLD
    TLCD
    TSRC

    # FLAGS
    CFLAGS
    CXXFLAGS
    LDFLAGS

    PATH

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
    BISON
    CC
    CPP
    CXX
    CXXCPP
    FLEX
    HOSTCC
    LEX
    MAKE
    MAKEFLAGS
    NM
    OBJCOPY
    OBJDUMP
    PKG_CONFIG
    RAD_RSYNC_FLAGS
    RANLIB
    READELF
    SIZE
    STRIP
    YACC


  radFiles* = enum
    boosterYaml = "booster.yaml"
    ceras
    configGuess = "config.guess"
    grubCfg = "grub.cfg"
    grubCfgImg = "grub.cfg.img"
    grubCfgIso = "grub.cfg.iso"
    imgSize = "16384"
    initramfs
    kernel = "vmlinuz"
    radLck = "rad.lck"
    rootfs
    sum
    tarZst = ".tar.zst"


  radFlags* = enum
    cflags = "-pipe -g0 -O2 -fdevirtualize-at-ltrans -fsched-pressure -fno-semantic-interposition -fipa-pta -fgraphite-identity -floop-nest-optimize -flto=auto -flto-compression-level=19 -fuse-linker-plugin -fstack-protector-strong -fstack-clash-protection -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -march=x86-64-v3 -mfpmath=sse -mabi=sysv -malign-data=cacheline -mtls-dialect=gnu2"
    Chown = "-Rv"
    cpp = "-E"
    gitCheckout = "checkout"
    gitClone = "clone"
    Grub = """--compress=no --fonts="" --locales="" --themes="" -v --core-compress=none"""
    ldflags = "-Wl,-O1,-s,-z,noexecstack,-z,now,-z,relro,-z,x86-64-v3,--as-needed,--gc-sections,--sort-common,--hash-style=gnu,--compress-debug-sections=zstd"
    make = "-j4 -O"
    Mke2fs = "-qt"
    Parted = "-s"
    Rsync = "-vaHAXSx"
    rsyncRelease = "-vaHAXx"
    shellCommand = "-c"
    shellRedirect = "> /dev/null 2>&1"
    tarCreate = "-cpvf"
    tarExtract = "-xmPvf"
    Umount = "-fqRv"
    zstdCompress = "-22 --ultra -T0 --long"
    zstdDecompress = "-d -T0 --long"


  radHelp* = enum
    Rad = """
USAGE:
  rad [ OPTION ]

OPTIONS:
  -b, --bootstrap  Bootstrap glaucus
  -c, --cerata     Manage cerata
  -h, --help       Display this help message
  -v, --version    Display current version"""

    bootstrap = """
USAGE:
  rad [ -b | --bootstrap ] [ COMMAND ]

COMMANDS:
  c, clean         Clean cache
  d, distclean     Clean everything
  h, help          Display this help message
  i, img           Release a glaucus IMG
  n, native        Bootstrap native glaucus
  r, release       Release a glaucus ISO
  t, toolchain     Bootstrap toolchain
  x, cross         Bootstrap cross glaucus"""

    Cerata = """
USAGE:
  rad [ -c | --cerata ] [ COMMAND ] [ cerata ]

COMMANDS:
  a, append        Append a cluster
  b, build         Build cerata
  c, clean         Clean cache
  d, distclean     Clean everything
  h, help          Display this help message
  i, install       Install cerata
  l, list          List installed cerata
  n, new           Create a new ceras
  p, print         Print cerata information
  r, remove        Remove cerata
  s, search        Search for cerata
  u, upgrade       Upgrade cerata
  y, sync          Synchronize clusters"""

    version = """
rad version 0.1.0

Copyright (c) 2018-2024, Firas Khalil Khana
Distributed under the terms of the ISC License"""


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

    # RAD
    radCacheBin = "/var/cache/rad/bin"
    radCacheSrc = "/var/cache/rad/src"
    radCacheVenom = "/var/cache/rad/venom"
    radLibClustersGlaucus = "/var/lib/rad/clusters/glaucus"
    radLibLocal = "/var/lib/rad/local"
    radLog = "/var/log/rad"
    radTmp = "/var/tmp/rad"


  radPrint* = enum
    build
    clone
    fetch
    install
    Nil = "nil"
    remove


  radStages* = enum
    cross
    native
    toolchain


  radTools* = enum
    ar = "gcc-ar"
    As = "as"
    chown
    cxx = "g++"
    dd
    git
    grubInstall = "grub-install"
    grubMkrescue = "grub-mkrescue"
    losetup
    mke2fs
    mkfs_erofs = "mkfs.erofs"
    modprobe
    mount
    nm = "gcc-nm"
    objcopy
    objdump
    parted
    partx
    ranlib = "gcc-ranlib"
    readelf
    sh
    size
    strip
    tar = "bsdtar"
    umount
