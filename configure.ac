dnl Process this file with autoconf to produce a configure script.

AC_PREREQ([2.62])
AC_INIT([MXE-Octave], [0.0.17], [http://octave.org/bugs.html], [mxe-octave])

AC_CONFIG_SRCDIR([src/octave.mk])
AC_CONFIG_AUX_DIR([tools])

### Check for bootstrap tools.  This list is probably not complete yet.

AC_PROG_AWK
AC_PROG_GREP
AC_PROG_LN_S
AC_PROG_MKDIR_P
AC_PROG_INSTALL
AC_PROG_CC
AC_PROG_CPP
AC_PROG_GCC_TRADITIONAL

dnl PKG_PROG_PKG_CONFIG
dnl OCTAVE_PROG_FIND
dnl OCTAVE_PROG_SED
dnl OCTAVE_PROG_PERL
dnl OCTAVE_PROG_GPERF
dnl OCTAVE_PROG_FLEX
dnl OCTAVE_PROG_BISON
dnl OCTAVE_PROG_MAKEINFO
dnl OCTAVE_PROG_TEXI2DVI
dnl OCTAVE_PROG_TEXI2PDF
dnl OCTAVE_PROG_GHOSTSCRIPT
dnl OCTAVE_PROG_GNUPLOT
dnl OCTAVE_PROG_PAGER
dnl OCTAVE_PROG_PYTHON
dnl OCTAVE_CHECK_LIB_TERMLIB

### Define the path to the shell on the host system.  Most systems will
### ensure /bin/sh is the default shell so this can be safely ignored by
### almost everyone.  However, when building for Android, for example,
### this will need to be set.
SHELL=bash
AC_ARG_WITH([shell],
  [AS_HELP_STRING([--with-shell=SHELL],
    [use SHELL as the shell interpreter (default: bash)])])
case $with_shell in
  no)
    AC_MSG_ERROR([A shell interpreter is required])
  ;;
  yes | "")
  ;;
  *)
    SHELL=$with_shell
  ;;
esac
AC_SUBST(SHELL)

### If possible, use a 64-bit integer type for array dimensions and indexing.

ENABLE_64=no
AC_ARG_ENABLE(64,
  [AS_HELP_STRING([--enable-64],
    [(EXPERIMENTAL) use 64-bit integers for array dimensions and indexing])],
  [if test "$enableval" = yes; then ENABLE_64=yes; fi], [])
AC_SUBST(ENABLE_64)

BUILD_SHARED=yes
AC_ARG_ENABLE(shared,
  [AS_HELP_STRING([--disable-shared], [Disable shared libraries])],
  [if test "$enableval" = no; then BUILD_SHARED=no; fi], [])
AC_SUBST(BUILD_SHARED)

BUILD_STATIC=no
AC_ARG_ENABLE(static,
  [AS_HELP_STRING([--enable-static], [Enable static libraries])],
  [if test "$enableval" = yes; then BUILD_STATIC=yes; fi], [])
AC_SUBST(BUILD_STATIC)

ENABLE_JIT=yes
AC_ARG_ENABLE([jit],
  [AS_HELP_STRING([--disable-jit], [Disable Octave JIT compiler])],
  [if test "$enableval" = no; then ENABLE_JIT=no; fi], [])
AC_SUBST(ENABLE_JIT)

ENABLE_JAVA=yes
AC_ARG_ENABLE([java],
  [AS_HELP_STRING([--disable-java], [Disable Java])],
  [if test "$enableval" = no; then ENABLE_JAVA=no; fi], [])
AC_SUBST(ENABLE_JAVA)

ENABLE_DOCS=yes
AC_ARG_ENABLE([docs],
  [AS_HELP_STRING([--disable-docs], [Disable Octave docs])],
  [if test "$enableval" = no; then ENABLE_DOCS=no; fi], [])
AC_SUBST(ENABLE_DOCS)

MXE_NATIVE_BUILD=no
AC_ARG_ENABLE([native-build],
  [AS_HELP_STRING([--enable-native-build],
    [Enable native build (default is cross compile)])],
  [if test "$enableval" = yes; then MXE_NATIVE_BUILD=yes; fi], [])
AC_SUBST(MXE_NATIVE_BUILD)

USE_SYSTEM_FONTCONFIG=$MXE_NATIVE_BUILD
AC_ARG_ENABLE([system-fontconfig],
  [AS_HELP_STRING([--enable-system-fontconfig],
    [Use fontconfig already installed on system])],
  [if test "$enableval" = yes; then USE_SYSTEM_FONTCONFIG=yes; else USE_SYSTEM_FONTCONFIG=no; fi], [])
AC_SUBST(USE_SYSTEM_FONTCONFIG)

USE_SYSTEM_GCC=$MXE_NATIVE_BUILD
AC_ARG_ENABLE([system-gcc],
  [AS_HELP_STRING([--enable-system-gcc],
    [Use GCC already installed on system])],
  [if test "$enableval" = yes; then USE_SYSTEM_GCC=yes; else USE_SYSTEM_GCC=no; fi], [])
AC_SUBST(USE_SYSTEM_GCC)

ENABLE_LIB64_DIRECTORY=no
AC_ARG_ENABLE(lib64-directory,
  [AS_HELP_STRING([--enable-lib64-directory],
    [Search lib64 directory for libraries])],
  [if test "$enableval" = yes; then ENABLE_LIB64_DIRECTORY=yes; fi], [])
AC_SUBST(ENABLE_LIB64_DIRECTORY)

USE_PIC_FLAG=no
AC_ARG_ENABLE([pic-flag],
  [AS_HELP_STRING([--enable-pic-flag], [Compile with PIC flag])],
  [if test "$enableval" = yes; then USE_PIC_FLAG=yes; fi], [])
AC_SUBST(USE_PIC_FLAG)

STRIP_DIST_FILES=yes
AC_ARG_ENABLE([strip-dist-files],
  [AS_HELP_STRING([--disable-strip-dist-files], [Don't strip distributed files])],
  [if test "$enableval" = no; then STRIP_DIST_FILES=no; fi], [])
AC_SUBST(STRIP_DIST_FILES)

ENABLE_OPENBLAS=no
AC_ARG_ENABLE([openblas],
  [AS_HELP_STRING([--enable-openblas],
    [(EXPERIMENTAL) enable use of openblas in Octave])],
  [if test "$enableval" = yes; then ENABLE_OPENBLAS=yes; fi], [])
AC_SUBST(ENABLE_OPENBLAS)

### Default is to cross compile for mingw.

echo $host_alias
if test -n "$host_alias"; then
  MXE_SYSTEM=$host_alias
else
  MXE_SYSTEM=mingw
fi
AC_SUBST(MXE_SYSTEM)

# set MXE_ROOTDIR for knowing the mxe root
MXE_ROOTDIR=`cd $srcdir; pwd`
AC_SUBST(MXE_ROOTDIR)

AC_CONFIG_FILES([Makefile tools/set-mxe-env.sh])

AC_OUTPUT

### End of configure.
