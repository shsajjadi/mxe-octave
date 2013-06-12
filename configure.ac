dnl Process this file with autoconf to produce a configure script.

AC_PREREQ([2.62])
AC_INIT([MXE-Octave], [0.0.1], [http://octave.org/bugs.html], [mxe-octave])

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
SHELL_PATH=/bin/sh
AC_ARG_WITH([shell],
  [AS_HELP_STRING([--with-shell=SHELL],
    [use SHELL as the shell interpreter (default: /bin/sh)])])
case $with_shell in
  no)
    AC_MSG_ERROR([A shell interpreter is required])
  ;;
  yes | "")
  ;;
  *)
    SHELL_PATH=$with_shell
  ;;
esac
AC_DEFINE_UNQUOTED([SHELL_PATH], ["$SHELL_PATH"],
  [Define this to be the path to the shell command interpreter.])

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
  [], [if test "$enableval" = no; then BUILD_SHARED=no; fi])
AC_SUBST(BUILD_SHARED)

BUILD_STATIC=no
AC_ARG_ENABLE(static,
  [AS_HELP_STRING([--enable-static], [Enable static libraries])],
  [if test "$enableval" = yes; then BUILD_STATIC=yes; fi], [])
AC_SUBST(BUILD_STATIC)

ENABLE_JIT=yes
AC_ARG_ENABLE([jit],
  [AS_HELP_STRING([--enable-jit],
    [(EXPERIMENTAL) enable Octave JIT compiler])],
  [if test "$enableval" = yes; then ENABLE_JIT=yes; fi], [])
AC_SUBST(ENABLE_JIT)

MXE_NATIVE_BUILD=false
AC_ARG_ENABLE([native-build],
  [AS_HELP_STRING([--enable-native-build],
    [Enable native build (default is cross compile)])],
  [if test "$enableval" = yes; then MXE_NATIVE_BUILD=yes; fi], [])
AC_SUBST(MXE_NATIVE_BUILD)

USE_SYSTEM_GCC=$MXE_NATIVE_BUILD
AC_ARG_ENABLE([system-gcc],
  [AS_HELP_STRING([--enable-system-gcc],
    [Use GCC already installed on system])],
  [if test "$enableval" = yes; then USE_SYSTEM_GCC=yes; fi], [])
AC_SUBST(USE_SYSTEM_GCC)

USE_PIC_FLAG=no
AC_ARG_ENABLE([pic-flag],
  [AS_HELP_STRING([--enable-pic-flag], [Compile with PIC flag])],
  [if test "$enableval" = yes; then USE_PIC_FLAG=yes; fi], [])
AC_SUBST(USE_PIC_FLAG)

### Default is to cross compile for mingw.

echo $host_alias
if test -n "$host_alias"; then
  MXE_SYSTEM=$host_alias
else
  MXE_SYSTEM=mingw
fi
AC_SUBST(MXE_SYSTEM)

AC_CONFIG_FILES([Makefile])

AC_OUTPUT

### End of configure.
