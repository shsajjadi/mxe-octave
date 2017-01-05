dnl Process this file with autoconf to produce a configure script.

AC_PREREQ([2.62])
AC_INIT([MXE-Octave], [0.0.35], [http://octave.org/bugs.html], [mxe-octave])

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

PKG_DIR="pkg"
AC_ARG_WITH([pkg-dir],
  [AS_HELP_STRING([--with-pkg-dir=DIR],
    [use DIR as the location for downloaded packages (default: pkg)])])
case $with_pkg_dir in
  no)
    AC_MSG_ERROR([A pkg directory is required])
  ;;
  yes | "")
  ;;
  *)
    PKG_DIR="$withval"
  ;;
esac
## Ensure directory exists and that we refer to it using an absolute name
if ! test -d "$PKG_DIR"; then
  mkdir -p "$PKG_DIR"
fi
PKG_DIR=`(cd "$PKG_DIR"; pwd)`
AC_SUBST(PKG_DIR)

AC_ARG_WITH([ccache],
  [AS_HELP_STRING([--with-ccache], [use ccache (default: no)])],
  [case $withval in
     no) USE_CCACHE=no ;;
     yes) USE_CCACHE=yes ;;
     *) AC_MSG_ERROR([bad value $enableval for --with-ccache]) ;;
   esac], [USE_CCACHE=no])
AC_SUBST(USE_CCACHE)

AC_ARG_ENABLE(windows-64,
  [AS_HELP_STRING([--disable-windows-64],
    [don't build a Windows 64 cross compiler])],
  [case $enableval in
     no) ENABLE_WINDOWS_64=no ;;
     yes) ENABLE_WINDOWS_64=yes ;;
     *) AC_MSG_ERROR([bad value $enableval for --enable-windows-64]) ;;
   esac], [ENABLE_WINDOWS_64=yes])

AC_ARG_ENABLE(64,
  [AS_HELP_STRING([--enable-64],
    [use 64-bit integers for array dimensions and indexing])],
  [case $enableval in
     no) ENABLE_64=no ;;
     yes) ENABLE_64=yes ;;
     *) AC_MSG_ERROR([bad value $enableval for --enable-64]) ;;
   esac], [ENABLE_64=unknown])

if test "$ENABLE_64" = unknown; then
  ENABLE_64="$ENABLE_WINDOWS_64"
fi

AC_ARG_ENABLE(fortran-int64,
  [AS_HELP_STRING([--enable-fortran-int64],
    [use 64-bit integers for fortran (and other) numerical library code])],
  [case $enableval in
     no) ENABLE_FORTRAN_INT64=no ;;
     yes) ENABLE_FORTRAN_INT64=yes ;;
     *) AC_MSG_ERROR([bad value $enableval for --enable-fortran-int64]) ;;
   esac], [ENABLE_FORTRAN_INT64=no])

if test "$ENABLE_64" = yes || test "$ENABLE_FORTRAN_INT64" = yes; then
  if test "$ENABLE_WINDOWS_64" = no; then
    AC_MSG_ERROR([--enable-fortran-int64 and --enable-64 both require --enable-windows-64])
  fi
fi

AC_SUBST(ENABLE_64)
AC_SUBST(ENABLE_FORTRAN_INT64)
AC_SUBST(ENABLE_WINDOWS_64)

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

ENABLE_JIT=no
AC_ARG_ENABLE([jit],
  [AS_HELP_STRING([--enable-jit], [Enable Octave JIT compiler])],
  [if test "$enableval" = yes; then ENABLE_JIT=yes; fi], [])
AC_SUBST(ENABLE_JIT)

ENABLE_JAVA=yes
AC_ARG_ENABLE([java],
  [AS_HELP_STRING([--disable-java], [Disable Java/Octave interface])],
  [if test "$enableval" = no; then ENABLE_JAVA=no; fi], [])
AC_SUBST(ENABLE_JAVA)

ENABLE_DOCS=yes
AC_ARG_ENABLE([docs],
  [AS_HELP_STRING([--disable-docs], [Disable building Octave documentation])],
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

USE_SYSTEM_X11_LIBS=$MXE_NATIVE_BUILD
AC_ARG_ENABLE([system-x11-libs],
  [AS_HELP_STRING([--enable-system-x11-libs],
    [Use X11 libraries already installed on system])],
  [if test "$enableval" = yes; then USE_SYSTEM_X11_LIBS=yes; else USE_SYSTEM_X11_LIBS=no; fi], [])
AC_SUBST(USE_SYSTEM_X11_LIBS)

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

ENABLE_OPENBLAS=yes
AC_ARG_ENABLE([openblas],
  [AS_HELP_STRING([--disable-openblas],
    [Disable use of OpenBLAS in Octave])],
  [if test "$enableval" = no; then ENABLE_OPENBLAS=no; fi], [])
AC_SUBST(ENABLE_OPENBLAS)

ENABLE_QHULL_NO_STRICT_ALIASING_FLAG=no
AC_ARG_ENABLE([qhull-no-strict-aliasing-flag],
  [AS_HELP_STRING([--enable-qhull-no-strict-aliasing-flag],
    [Compile Qhull with -fno-strict-aliasing flag])],
  [if test "$enableval" = yes; then
     ENABLE_QHULL_NO_STRICT_ALIASING_FLAG=yes;
   fi], [])
AC_SUBST(ENABLE_QHULL_NO_STRICT_ALIASING_FLAG)

ENABLE_OCTAVE=stable
AC_ARG_ENABLE([octave],
  [AS_HELP_STRING([--enable-octave=stable],
    [Enable a specific build of Octave (stable, alpha, default)])],
  [], [enableval=$ENABLE_OCTAVE])

case $enableval in
 stable)
   ENABLE_OCTAVE="stable-"
   ;;
 alpha)
   ENABLE_OCTAVE=""
   ;;
 default)
   ENABLE_OCTAVE="default-"
   ;;
 *)
   ENABLE_OCTAVE="stable-"
   AC_MSG_WARN([Unknown octave type $enableval - using enable-octave=stable])
   ;;
esac
   
AC_SUBST(ENABLE_OCTAVE)

ENABLE_BINARY_PACKAGES=no
AC_ARG_ENABLE([binary-packages],
  [AS_HELP_STRING([--enable-binary-packages],
    [Enable creating binary Octave Forge packages])],
  [if test "$enableval" = yes; then ENABLE_BINARY_PACKAGES=yes; fi], [])
AC_SUBST(ENABLE_BINARY_PACKAGES)

ENABLE_DEVEL_TOOLS=no
AC_ARG_ENABLE([devel-tools],
  [AS_HELP_STRING([--enable-devel-tools],
    [Enable creating developer tools such as gdb])],
  [if test "$enableval" = yes; then ENABLE_DEVEL_TOOLS=yes; fi], [])
AC_SUBST(ENABLE_DEVEL_TOOLS)

ENABLE_QT5=no
AC_ARG_ENABLE([qt5],
  [AS_HELP_STRING([--enable-qt5],
    [Enable compile of GNU octave using Qt5 (Experimental)])],
  [if test "$enableval" = yes; then ENABLE_QT5=yes; fi], [])
AC_SUBST(ENABLE_QT5)

# install dependancy package docs (or not to save space)
ENABLE_DEP_DOCS=no
AC_ARG_ENABLE([dep-docs],
	      [AS_HELP_STRING([--enable-dep-docs],
			      [Enable install of dependancy package dos])],
  [if test "$enableval" = yes; then ENABLE_DEP_DOCS=yes; fi], [])
AC_SUBST(ENABLE_DEP_DOCS)


### Default is to cross compile for mingw.

echo $host_alias
if test -n "$host_alias"; then
  MXE_SYSTEM=$host_alias
else
  MXE_SYSTEM=mingw
fi
AC_SUBST(MXE_SYSTEM)

# set MXE_ROOTDIR for knowing the mxe root
MXE_ROOTDIR=`cd "$builddir"; pwd`
AC_SUBST(MXE_ROOTDIR)

if test "$MXE_NATIVE_BUILD" = no; then
  if test "$ENABLE_WINDOWS_64" = yes; then
    MXE_TARGET=x86_64-w64-mingw32
  else
    MXE_TARGET=i686-w64-mingw32
  fi
fi
AC_SUBST(MXE_TARGET)

AC_CONFIG_FILES([Makefile tools/set-mxe-env.sh])
AC_CONFIG_FILES([tools/makeinst-script.sh], [chmod a+x tools/makeinst-script.sh])

AC_OUTPUT

### End of configure.
