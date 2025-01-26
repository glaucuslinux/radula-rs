# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[os, strformat], cerata, constants

proc buildCross*() =
  buildCerata(
    [
      # Filesystem
      $fs,

      # Development
      $radCerata.cerata,
      $expat,
      $linuxHeaders,
      $muslUtils,
      $netbsdCurses,
      $pkgconf,

      # Init
      $skalibs,
      $execline,
      $mdevd,
      $s6,
      $utmps,

      # Security
      $attr,
      $acl,
      $libcap,
      $libressl,
      $shadow,

      # Compression
      $zlibNg,
      $bzip2,
      $pigz,
      $lz4,
      $xz,
      $zstd,
      $libarchive,

      # Development
      $autoconf,
      $binutils,
      $file,
      $flex,
      $gcc,
      $gettextTiny,
      $libedit,
      $m4,
      $radCerata.make,
      $mawk,
      $pcre2,
      $slibtool,

      # Utilities
      $dash,
      $grep,
      $kmod,
      $libudevZero,
      $toybox,
      $utilLinux,
      $xxhash,

      # Services
      $s6LinuxInit,
      $s6Rc,
      $s6BootScripts,

      # Kernel
      $linuxCachyOS,
    ],
    $cross,
    false,
  )

proc buildNative*() =
  buildCerata(
    [
      # Filesystem
      $fs,

      # Development
      $radCerata.cerata,
      $linuxHeaders,
      $musl,
      $perl,
      $automake,
      $bash,
      # $cmake,
      $gmp,
      $gperf,
      $bison,
      $mpfr,
      $mpc,
      $isl,

      # Security
      $acl,
      $attr,
      $libcap,
      $libressl,
      $shadow,

      # Compression
      $bzip2,
      $pigz,
      $libarchive,
      $lz4,
      $xz,
      $zlibNg,
      $zstd,

      # Development
      $autoconf,
      $binutils,
      $expat,
      $file,
      $flex,
      $gcc,
      $gettextTiny,
      $libedit,
      $m4,
      $radCerata.make,
      $mawk,
      $netbsdCurses,
      $pcre2,
      $pkgconf,
      $samurai,
      $slibtool,

      # Networking
      $curl,
      $eiwd,
      $fping,
      # $iproute2,
      $openresolv,
      $sdhcp,
      $wget2,

      # Utilities
      $grep,
      $hwdata,
      $kmod,
      $less,
      $libudevZero,
      $neatvi,
      $pciutils,
      $toybox,
      $utilLinux,
      $xxhash,
      $yash,

      # Init & Services
      $skalibs,
      $execline,
      $mdevd,
      $s6,
      $utmps,
      $s6LinuxInit,
      $s6Rc,
      $s6BootScripts,

      # Kernel
      $linuxCachyOS,
    ],
    $native,
    false,
  )

proc buildToolchain*() =
  buildCerata(
    [$muslHeaders, $binutils, $gcc, $musl, $libgcc, $libstdcxxV3], $toolchain, false
  )

proc cleanBootstrap*() =
  removeDir(getEnv($CRSD))
  removeDir(getEnv($LOGD))
  removeDir(getEnv($TMPD))
  removeDir(getEnv($TLCD))

proc distcleanBootstrap*() =
  cleanBootstrap()

  removeDir(getEnv($PKGD))
  removeDir(getEnv($SRCD))

proc prepareBootstrap*() =
  createDir(getEnv($CRSD))
  createDir(getEnv($LOGD))
  createDir(getEnv($PKGD))
  createDir(getEnv($SRCD))
  createDir(getEnv($TMPD))
  createDir(getEnv($TLCD))

proc prepareCross*() =
  removeDir(getEnv($TMPD))
  createDir(getEnv($TMPD))

proc setEnvBootstrap*() =
  let path = parentDir(getCurrentDir())

  putEnv($GLAD, path)

  putEnv($CERD, path / $radCerata.cerata)
  putEnv($CRSD, path / $cross)
  putEnv($LOGD, path / $log)
  putEnv($PKGD, path / $pkg)
  putEnv($SRCD, path / $src)
  putEnv($TMPD, path / $tmp)
  putEnv($TLCD, path / $toolchain)

  putEnv($PATH, getEnv($TLCD) / $usr / &"{bin}{PathSep}{getEnv($PATH)}")

proc setEnvCrossTools*() =
  let crossCompile = &"{getEnv($TGT)}-"

  putEnv($CROSS_COMPILE, crossCompile)

  putEnv($AR, &"{crossCompile}{ar}")
  putEnv($radEnv.AS, &"{crossCompile}{radTools.As}")
  putEnv($CC, &"{crossCompile}{gcc}")
  putEnv($radEnv.CPP, &"{getEnv($CC)} {cpp}")
  putEnv($CXX, &"{crossCompile}{cxx}")
  putEnv($CXXCPP, &"{getEnv($CXX)} {cpp}")
  putEnv($HOSTCC, $gcc)
  putEnv($NM, &"{crossCompile}{nm}")
  putEnv($OBJCOPY, &"{crossCompile}{objcopy}")
  putEnv($OBJDUMP, &"{crossCompile}{objdump}")
  putEnv($PKG_CONFIG_LIBDIR, getEnv($CRSD) / $pkgConfigLibdir)
  putEnv($PKG_CONFIG_PATH, getEnv($PKG_CONFIG_LIBDIR))
  putEnv($PKG_CONFIG_SYSROOT_DIR, &"{getEnv($CRSD)}{DirSep}")
  # `pkgconf` specific extensions
  putEnv($PKG_CONFIG_SYSTEM_INCLUDE_PATH, getEnv($CRSD) / $pkgConfigSystemIncludePath)
  putEnv($PKG_CONFIG_SYSTEM_LIBRARY_PATH, getEnv($CRSD) / $pkgConfigSystemLibraryPath)
  putEnv($RANLIB, &"{crossCompile}{ranlib}")
  putEnv($READELF, &"{crossCompile}{readelf}")
  putEnv($SIZE, &"{crossCompile}{size}")
  putEnv($STRIP, &"{crossCompile}{strip}")

proc setEnvNativeDirs*() =
  putEnv($CERD, $radClustersCerataLib)
  putEnv($LOGD, $radLog)
  putEnv($PKGD, $radPkgCache)
  putEnv($SRCD, $radSrcCache)
  putEnv($TMPD, $radTmp)

proc setEnvNativeTools*() =
  putEnv($AR, $ar)
  putEnv($AWK, $mawk)
  putEnv($CC, $gcc)
  putEnv($radEnv.CPP, &"{gcc} {cpp}")
  putEnv($CXX, $cxx)
  putEnv($CXXCPP, &"{cxx} {cpp}")
  putEnv($LEX, $flex)
  putEnv($LIBTOOL, $slibtool)
  putEnv($NM, $nm)
  putEnv($PKG_CONFIG, $pkgconf)
  putEnv($RANLIB, $ranlib)
