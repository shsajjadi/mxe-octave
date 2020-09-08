dnl Process this file with autoconf to produce a configure script.

AC_PREREQ([2.62])
AC_INIT([MXE-Octave], [0.0.35], [https://octave.org/bugs.html], [mxe-octave])

AC_CONFIG_SRCDIR([src/default-octave.mk])
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
SHELL=/bin/bash
AC_ARG_WITH([shell],
  [AS_HELP_STRING([--with-shell=SHELL],
    [use SHELL as the shell interpreter (default: /bin/bash)])])
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
     *) AC_MSG_ERROR([bad value "$enableval" for --with-ccache]) ;;
   esac], [USE_CCACHE=no])
if test "$USE_CCACHE" = yes; then
  AC_PATH_PROG(CCACHE, ccache)
  if test -z "$CCACHE"; then
    AC_MSG_WARN([ccache program not found; not using ccache for build])
    USE_CCACHE=no
  fi
fi
AC_SUBST(USE_CCACHE)

AC_ARG_WITH([msys2],
  [AS_HELP_STRING([--with-msys2], [use msys2 in windows distribution (default: yes)])],
  [case $withval in
     no) USE_MSYS2=no ;;
     yes) USE_MSYS2=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --with-msys2]) ;;
   esac], [USE_MSYS2=yes])
AC_SUBST(USE_MSYS2)

# try find pkg-config build paths
BUILD_PKG_CONFIG_PATH=auto
AC_ARG_WITH([build-pkg-config-path],
  [AS_HELP_STRING([--with-build-pkg-config-path=PATH],
		  [use PATH as the build pkg-config path (default: auto)])],
  [BUILD_PKG_CONFIG_PATH=$withval],
  [BUILD_PKG_CONFIG_PATH=auto])

if test "x$BUILD_PKG_CONFIG_PATH" = "xauto"; then
  PKG_CHECK_VAR([BUILDPKGCONFIGPATH], [pkg-config], [pc_path])
  AC_MSG_CHECKING([for build pkg-config paths])
  if test "x$BUILDPKGCONFIGPATH" = "x"; then
    AC_MSG_RESULT([couldnt auto detect pkg-config paths"])
    BUILD_PKG_CONFIG_PATH=""
  else
    BUILD_PKG_CONFIG_PATH="$BUILDPKGCONFIGPATH"
    AC_MSG_RESULT([$BUILD_PKG_CONFIG_PATH])
  fi
fi
AC_SUBST(BUILD_PKG_CONFIG_PATH)


AC_ARG_ENABLE([windows-64],
  [AS_HELP_STRING([--disable-windows-64],
    [build Windows 32bit binaries (default: enable, i.e. 64bit binaries)])],
  [case $enableval in
     no) ENABLE_WINDOWS_64=no ;;
     yes) ENABLE_WINDOWS_64=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-windows-64]) ;;
   esac], [ENABLE_WINDOWS_64=yes])

AC_ARG_ENABLE([64],
  [AS_HELP_STRING([--enable-64],
    [use 64-bit integers for array dimensions and indexing])],
  [case $enableval in
     no) ENABLE_64=no ;;
     yes) ENABLE_64=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-64]) ;;
   esac], [ENABLE_64=unknown])

if test "$ENABLE_64" = unknown; then
  ENABLE_64="$ENABLE_WINDOWS_64"
fi

AC_ARG_ENABLE([fortran-int64],
  [AS_HELP_STRING([--enable-fortran-int64],
    [use 64-bit integers for fortran (and other) numerical library code (default: disable)])],
  [case $enableval in
     no) ENABLE_FORTRAN_INT64=no ;;
     yes) ENABLE_FORTRAN_INT64=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-fortran-int64]) ;;
   esac], [ENABLE_FORTRAN_INT64=no])

if test "$ENABLE_64" = yes || test "$ENABLE_FORTRAN_INT64" = yes; then
  if test "$ENABLE_WINDOWS_64" = no; then
    AC_MSG_ERROR([--enable-fortran-int64 and --enable-64 both require --enable-windows-64])
  fi
fi

AC_SUBST(ENABLE_64)
AC_SUBST(ENABLE_FORTRAN_INT64)
AC_SUBST(ENABLE_WINDOWS_64)

AC_ARG_ENABLE([shared],
  [AS_HELP_STRING([--disable-shared], [Disable shared libraries (default: enable)])],
  [case "$enableval" in
     no) BUILD_SHARED=no ;;
     yes) BUILD_SHARED=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-shared]) ;;
   esac], [BUILD_SHARED=yes])
AC_SUBST(BUILD_SHARED)

AC_ARG_ENABLE([static],
  [AS_HELP_STRING([--enable-static], [Enable static libraries (default: disable)])],
  [case "$enableval" in
     no) BUILD_STATIC=no ;;
     yes) BUILD_STATIC=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-static]) ;;
   esac], [BUILD_STATIC=no])
AC_SUBST(BUILD_STATIC)

AC_ARG_ENABLE([jit],
  [AS_HELP_STRING([--enable-jit], [Enable Octave JIT compiler (default: disable)])],
  [case "$enableval" in
     no) ENABLE_JIT=no ;;
     yes) ENABLE_JIT=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-jit]) ;;
   esac], [ENABLE_JIT=no])
AC_SUBST(ENABLE_JIT)

AC_ARG_ENABLE([java],
  [AS_HELP_STRING([--disable-java], [Disable Java/Octave interface (default: enable)])],
  [case "$enableval" in
     no) ENABLE_JAVA=no ;;
     yes) ENABLE_JAVA=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-java]) ;;
   esac], [ENABLE_JAVA=yes])
AC_SUBST(ENABLE_JAVA)

AC_ARG_ENABLE([[docs]],
  [AS_HELP_STRING([--disable-docs], [Disable building Octave documentation (default: enable)])],
  [case "$enableval" in
     no) ENABLE_DOCS=no ;;
     yes) ENABLE_DOCS=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-[docs]]) ;;
   esac], [ENABLE_DOCS=yes])
AC_SUBST(ENABLE_DOCS)

AC_ARG_ENABLE([[native-build]],
  [AS_HELP_STRING([--enable-native-build],
    [Enable native build (default is cross compile for mingw)])],
  [case "$enableval" in
     no) MXE_NATIVE_BUILD=no ;;
     yes) MXE_NATIVE_BUILD=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-[native-build]]) ;;
   esac], [MXE_NATIVE_BUILD=no])
AC_SUBST(MXE_NATIVE_BUILD)

AC_ARG_ENABLE([system-fontconfig],
  [AS_HELP_STRING([--enable-system-fontconfig],
    [Use fontconfig already installed on system (default: disable, i.e. build package)])],
  [case "$enableval" in
     no) USE_SYSTEM_FONTCONFIG=no ;;
     yes) USE_SYSTEM_FONTCONFIG=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-system-fontconfig]) ;;
   esac], [USE_SYSTEM_FONTCONFIG=$MXE_NATIVE_BUILD])
AC_SUBST(USE_SYSTEM_FONTCONFIG)

AC_ARG_ENABLE([system-opengl],
  [AS_HELP_STRING([--disable-system-opengl],
    [Use OpenGL libraries already installed on system (default: disable, i.e. build package)])],
  [case "$enableval" in
     no) USE_SYSTEM_OPENGL=no ;;
     yes) USE_SYSTEM_OPENGL=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-system-opengl]) ;;
   esac], [USE_SYSTEM_OPENGL=$MXE_NATIVE_BUILD])
AC_SUBST(USE_SYSTEM_OPENGL)

AC_ARG_ENABLE([system-x11-libs],
  [AS_HELP_STRING([--enable-system-x11-libs],
    [Use X11 libraries already installed on system (default: disable, i.e. build package)])],
  [case "$enableval" in
     no) USE_SYSTEM_X11_LIBS=no ;;
     yes) USE_SYSTEM_X11_LIBS=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-system-x11-libs]) ;;
   esac], [USE_SYSTEM_X11_LIBS=$MXE_NATIVE_BUILD])
AC_SUBST(USE_SYSTEM_X11_LIBS)

AC_ARG_ENABLE([system-gcc],
  [AS_HELP_STRING([--enable-system-gcc],
    [Use GCC already installed on system (default: disable, i.e. build package)])],
  [case "$enableval" in
     no) USE_SYSTEM_GCC=no ;;
     yes) USE_SYSTEM_GCC=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-system-gcc]) ;;
   esac], [USE_SYSTEM_GCC=$MXE_NATIVE_BUILD])
AC_SUBST(USE_SYSTEM_GCC)

AC_ARG_ENABLE([lib64-directory],
  [AS_HELP_STRING([--enable-lib64-directory],
    [Search lib64 directory for libraries (default: disable)])],
  [case "$enableval" in
     no) ENABLE_LIB64_DIRECTORY=no ;;
     yes) ENABLE_LIB64_DIRECTORY=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-lib64-directory]) ;;
   esac], [ENABLE_LIB64_DIRECTORY=no])
AC_SUBST(ENABLE_LIB64_DIRECTORY)

AC_ARG_ENABLE([pic-flag],
  [AS_HELP_STRING([--enable-pic-flag], [Compile with PIC flag (default: disable)])],
  [case "$enableval" in
     no) USE_PIC_FLAG=no ;;
     yes) USE_PIC_FLAG=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-pic-flag]) ;;
   esac], [USE_PIC_FLAG=no])
AC_SUBST(USE_PIC_FLAG)

AC_ARG_ENABLE([strip-dist-files],
  [AS_HELP_STRING([--disable-strip-dist-files], [Don't strip distributed files (default: enable)])],
  [case "$enableval" in
     no) STRIP_DIST_FILES=no ;;
     yes) STRIP_DIST_FILES=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-strip-dist-files]) ;;
   esac], [STRIP_DIST_FILES=yes])
AC_SUBST(STRIP_DIST_FILES)

AC_ARG_ENABLE([openblas],
  [AS_HELP_STRING([--disable-openblas],
    [Disable use of OpenBLAS in Octave (default: enable, i.e. build and use package)])],
  [case "$enableval" in
     no) ENABLE_OPENBLAS=no ;;
     yes) ENABLE_OPENBLAS=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-openblas]) ;;
   esac], [ENABLE_OPENBLAS=yes])
AC_SUBST(ENABLE_OPENBLAS)

AC_ARG_ENABLE([qhull-no-strict-aliasing-flag],
  [AS_HELP_STRING([--enable-qhull-no-strict-aliasing-flag],
    [Compile Qhull with -fno-strict-aliasing flag (default: disable)])],
  [case "$enableval" in
     no) ENABLE_QHULL_NO_STRICT_ALIASING_FLAG=no ;;
     yes) ENABLE_QHULL_NO_STRICT_ALIASING_FLAG=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-qhull-no-strict-aliasing-flag]) ;;
   esac], [ENABLE_QHULL_NO_STRICT_ALIASING_FLAG=no])
AC_SUBST(ENABLE_QHULL_NO_STRICT_ALIASING_FLAG)

AC_ARG_ENABLE([octave],
  [AS_HELP_STRING([--enable-octave=stable],
    [Enable a specific build of Octave (release, stable, default) (default: "release")])],
  [case $enableval in
     release) ENABLE_OCTAVE="release-" ;;
     stable) ENABLE_OCTAVE="stable-" ;;
     default) ENABLE_OCTAVE="default-" ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-octave]) ;;
   esac], [ENABLE_OCTAVE="release-"])
AC_SUBST(ENABLE_OCTAVE)

AC_ARG_ENABLE([binary-packages],
  [AS_HELP_STRING([--enable-binary-packages],
    [Enable building binary Octave Forge packages (default: disable)])],
  [case "$enableval" in
     no) ENABLE_BINARY_PACKAGES=no ;;
     yes) ENABLE_BINARY_PACKAGES=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-binary-packages]) ;;
   esac], [ENABLE_BINARY_PACKAGES=no])
AC_SUBST(ENABLE_BINARY_PACKAGES)

AC_ARG_ENABLE([system-octave],
  [AS_HELP_STRING([--disable-system-octave],
    [Build a minimal Octave that runs on the build system. This only applies if binary packages are cross-built (default: enable, i.e. use an already installed Octave)])],
  [case "$enableval" in
     no) USE_SYSTEM_OCTAVE=no ;;
     yes) USE_SYSTEM_OCTAVE=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --disable-system-octave]) ;;
   esac], [USE_SYSTEM_OCTAVE=yes])
AC_SUBST(USE_SYSTEM_OCTAVE)

AC_ARG_ENABLE([devel-tools],
  [AS_HELP_STRING([--enable-devel-tools],
    [Enable building developer tools such as gdb (default: disable)])],
  [case "$enableval" in
     no) ENABLE_DEVEL_TOOLS=no ;;
     yes) ENABLE_DEVEL_TOOLS=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-devel-tools]) ;;
   esac], [ENABLE_DEVEL_TOOLS=no])
AC_SUBST(ENABLE_DEVEL_TOOLS)

AC_ARG_ENABLE([qt5],
  [AS_HELP_STRING([--disable-qt5],
    [Build GNU Octave using Qt 4 instead of the default Qt 5 (default: enable, i.e. use Qt5)])],
  [case "$enableval" in
     no) ENABLE_QT5=no ;;
     yes) ENABLE_QT5=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-qt5]) ;;
   esac], [ENABLE_QT5=yes])
AC_SUBST(ENABLE_QT5)

# install documentation of build dependency packages (or not to save space)
AC_ARG_ENABLE([dep-docs],
  [AS_HELP_STRING([--enable-dep-docs],
    [Enable installation of documentation for dependency packages (default: disable)])],
  [case "$enableval" in
     no) ENABLE_DEP_DOCS=no ;;
     yes) ENABLE_DEP_DOCS=yes ;;
     *) AC_MSG_ERROR([bad value "$enableval" for --enable-dep-docs]) ;;
   esac], [ENABLE_DEP_DOCS=no])
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
