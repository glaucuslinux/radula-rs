# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

type
  RAD_ARCH* = enum
    glaucus

    TUPLE_CROSS = "-glaucus-linux-musl"
    TUPLE_NATIVE = "-pc-linux-musl"

    X86_64 = "x86-64"
    X86_64_LINUX = "x86_64"
    X86_64_V3 = "x86-64-v3"


  RAD_CERATA* = enum
    acl
    attr
    autoconf
    automake

    bash
    binutils
    booster
    byacc
    bzip2

    CERATA = "cerata"
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
    gettext_tiny = "gettext-tiny"
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
    libcap_ng = "libcap-ng"
    libedit
    libgcc
    libressl
    libstdcxx_v3 = "libstdc++-v3"
    libtool
    libudev_zero = "libudev-zero"
    linux
    linux_headers = "linux-headers"
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
    musl_fts = "musl-fts"
    musl_headers = "musl-headers"
    musl_utils = "musl-utils"

    netbsd_curses = "netbsd-curses"
    nsss

    opendoas

    patch
    pcre2
    perl
    pigz
    pkgconf
    procps_ng = "procps-ng"
    psmisc

    rad
    rsync

    s6
    s6_boot_scripts = "s6-boot-scripts"
    s6_linux_init = "s6-linux-init"
    s6_rc = "s6-rc"
    samurai
    sdhcp
    sed
    shadow
    skalibs

    texinfo
    toybox
    tzcode
    tzdata

    util_linux = "util-linux"
    utmps

    vim

    wget2

    xxhash
    xz

    yash

    zlib_ng = "zlib-ng"
    zstd


  RAD_DIRS* = enum
    bak
    bld
    iso
    log
    sac
    src
    tmp


  RAD_ENV* = enum
    # ARCH
    ARCH
    BOOTSTRAP
    CARCH
    CROSS_COMPILE
    PRETTY_NAME

    BLD
    TGT

    # DIR
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

    # PATHS
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


  RAD_FILES* = enum
    booster_yaml = "booster.yaml"
    ceras
    config_guess = "config.guess"
    grub_cfg = "grub.cfg"
    grub_cfg_img = "grub.cfg.img"
    grub_cfg_iso = "grub.cfg.iso"
    img_size = "16384"
    initramfs
    kernel = "vmlinuz"
    rad_lck = "rad.lck"
    rootfs
    sum
    tar_zst = ".tar.zst"


  RAD_FLAGS* = enum
    CFLAGS = "-pipe -g0 -O2 -fdevirtualize-at-ltrans -fsched-pressure -fno-semantic-interposition -fipa-pta -fgraphite-identity -floop-nest-optimize -flto=auto -flto-compression-level=19 -fuse-linker-plugin -fstack-protector-strong -fstack-clash-protection -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -march=x86-64-v3 -mfpmath=sse -mabi=sysv -malign-data=cacheline -mtls-dialect=gnu2"
    LDFLAGS = "-Wl,-O1,-s,-z,noexecstack,-z,now,-z,relro,-z,x86-64-v3,--as-needed,--gc-sections,--sort-common,--hash-style=gnu,--compress-debug-sections=zstd"

    # TOOLS
    CHOWN = "-Rv"
    CPP = "-E"
    GIT_CHECKOUT = "checkout"
    GIT_CLONE = "clone"
    GRUB = """--compress=no --fonts="" --locales="" --themes="" -v --core-compress=none"""
    MAKE = "-j4 -O"
    MKE2FS = "-qt"
    PARTED = "-s"
    RSYNC = "-vaHAXSx"
    RSYNC_RELEASE = "-vaHAXx"
    SHELL_COMMAND = "-c"
    SHELL_REDIRECT = "> /dev/null 2>&1"
    TAR_CREATE = "-cpvf"
    TAR_EXTRACT = "-xmPvf"
    UMOUNT = "-fqRv"
    ZSTD_COMPRESS = "-22 --ultra -T0 --long"
    ZSTD_DECOMPRESS = "-d -T0 --long"


  RAD_HELP* = enum
    RAD = """
USAGE:
  rad [ OPTION ]

OPTIONS:
  -b, --bootstrap  Bootstrap glaucus
  -c, --cerata     Manage cerata
  -h, --help       Display this help message
  -v, --version    Display current version"""

    BOOTSTRAP = """
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

    CERATA = """
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

    VERSION = """
rad version 0.1.0

Copyright (c) 2018-2024, Firas Khalil Khana
Distributed under the terms of the ISC License"""


  RAD_PATHS* = enum
    # FHS
    bin
    boot
    doc
    etc
    info
    lib
    lib64
    lost_found = "lost+found"
    man
    mnt
    modules
    share
    usr
    VAR = "var"
    wtmpd

    # `pkgconf` and `pkg-config` don't respect the provided sysroot (it doesn't get
    # automatically prefixed to PATH and LIBDIR)
    PKG_CONFIG_LIBDIR = "/usr/lib/pkgconfig"
    PKG_CONFIG_SYSTEM_INCLUDE_PATH = "/usr/include"
    PKG_CONFIG_SYSTEM_LIBRARY_PATH = "/usr/lib"

    # RAD
    RAD_CACHE_BIN = "/var/cache/rad/bin"
    RAD_CACHE_SRC = "/var/cache/rad/src"
    RAD_CACHE_VENOM = "/var/cache/rad/venom"
    RAD_LIB_CLUSTERS_GLAUCUS = "/var/lib/rad/clusters/glaucus"
    RAD_LIB_LOCAL = "/var/lib/rad/local"
    RAD_LOG = "/var/log/rad"
    RAD_TMP = "/var/tmp/rad"


  RAD_PRINT* = enum
    build
    clone
    fetch
    install
    NIL = "nil"
    remove


  RAD_STAGES* = enum
    cross
    native
    toolchain


  RAD_TOOLS* = enum
    ar = "gcc-ar"
    AS = "as"
    chown
    cxx = "g++"
    dd
    git
    grub_install = "grub-install"
    grub_mkrescue = "grub-mkrescue"
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
