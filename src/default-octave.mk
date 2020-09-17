# This file is part of MXE.
# See index.html for further information.

## This set of rules is intended for building the latest sources from
## the default branch of the Octave hg archive.  The $(PKG)_URL is
## intentionally set to an invalid value.  You must create a tar.lz
## file from the default branch of the Octave hg archive separately
## and place it in the directory where mxe-octave package sources are
## found.

## We omit the package checksum so that we don't have to update it
## each time the tarball changes.

PKG             := default-octave
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.0
$(PKG)_CHECKSUM := ## No checksum
$(PKG)_SUBDIR   := octave-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.lz
$(PKG)_URL      := http://not.a.valid.url/$($(PKG)_FILE)
ifeq ($(USE_SYSTEM_FONTCONFIG),no)
  $(PKG)_FONTCONFIG := fontconfig
endif
$(PKG)_DEPS     := blas arpack curl epstool fftw fltk $($(PKG)_FONTCONFIG) ghostscript gl2ps glpk gnuplot graphicsmagick hdf5 lapack libsndfile pcre portaudio pstoedit qhull qrupdate qscintilla rapidjson readline sundials-ida suitesparse texinfo zlib

ifeq ($(ENABLE_QT5),yes)
    $(PKG)_DEPS += qt5
else
    $(PKG)_DEPS += qt
endif

ifeq ($(USE_SYSTEM_OPENGL),no)
  $(PKG)_DEPS += mesa
endif

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_WITH_BLAS_CONFIGURE_OPTIONS := --with-blas="-lblas -lxerbla"
else
  $(PKG)_WITH_BLAS_CONFIGURE_OPTIONS := --with-blas="-lblas"
  ifeq ($(USE_SYSTEM_X11_LIBS),no)
    $(PKG)_DEPS += x11 xext
  endif
endif

ifeq ($(MXE_SYSTEM),mingw)
  ifeq ($(USE_SYSTEM_GCC),no)
    $(PKG)_DEPS     += libgomp
  endif
endif

ifeq ($(ENABLE_JIT),yes)
  $(PKG)_DEPS += llvm
  $(PKG)_ENABLE_JIT_CONFIGURE_OPTIONS := --enable-jit
else
  $(PKG)_ENABLE_JIT_CONFIGURE_OPTIONS := --disable-jit
endif

ifeq ($(ENABLE_JAVA),no)
  $(PKG)_ENABLE_JAVA_CONFIGURE_OPTIONS := --disable-java
else
  ifeq ($(MXE_SYSTEM),mingw)
    ifeq ($(MXE_NATIVE_BUILD),no)
      $(PKG)_ENABLE_JAVA_CONFIGURE_OPTIONS := \
       --with-java-includedir="$(HOST_INCDIR)/java"
     endif
  endif
endif

## If we allow the system Qt libraries to be used, then these
## won't make sense.
$(PKG)_QT_CONFIGURE_OPTIONS := \
  MOC_QTVER=$(MXE_MOC) \
  UIC_QTVER=$(MXE_UIC) \
  RCC_QTVER=$(MXE_RCC) \
  LRELEASE_QTVER=$(MXE_LRELEASE)

ifeq ($(ENABLE_QT5),yes)
  #$(PKG)_PKG_CONFIG_PATH := "$(HOST_LIBDIR)/pkgconfig"
  $(PKG)_PKG_CONFIG_PATH := "$(HOST_PREFIX)/qt5/lib/pkgconfig:$(HOST_LIBDIR)/pkgconfig"
  $(PKG)_QTDIR := $(HOST_PREFIX)/qt5
  $(PKG)_QT_CONFIGURE_OPTIONS += octave_cv_lib_qscintilla="-lqscintilla2_qt5"
else
  $(PKG)_PKG_CONFIG_PATH := "$(HOST_LIBDIR)/pkgconfig"
  $(PKG)_QTDIR := $(HOST_PREFIX)
  $(PKG)_QT_CONFIGURE_OPTIONS += octave_cv_lib_qscintilla="-lqscintilla2_qt4"
endif


ifneq ($(ENABLE_DOCS),yes)
  $(PKG)_ENABLE_DOCS_CONFIGURE_OPTIONS := --disable-docs
endif

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_ENV := LD_LIBRARY_PATH=$(LD_LIBRARY_PATH)
  ifeq ($(ENABLE_64),yes)
    $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := --enable-64
  else
    $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := --disable-64
  endif
else
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CROSS_CONFIG_OPTIONS := \
      FLTK_CONFIG='$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)fltk-config' \
      gl_cv_func_gettimeofday_clobber=no \
      gl_cv_func_tzset_clobber=no
    ifeq ($(ENABLE_64),yes)
      $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := --enable-64
    else
      $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := --disable-64
    endif
  endif
endif

ifeq ($(ENABLE_FORTRAN_INT64),yes)
  $(PKG)_ENABLE_FORTRAN_INT64_CONFIGURE_OPTIONS := F77_INTEGER_8_FLAG=-fdefault-integer-8 ax_blas_f77_func_ok=yes ax_blas_integer_size=8 octave_cv_sizeof_fortran_integer=8
else
  $(PKG)_ENABLE_FORTRAN_INT64_CONFIGURE_OPTIONS := ax_blas_f77_func_ok=yes ax_blas_integer_size=4 octave_cv_sizeof_fortran_integer=4
endif

ifeq ($(MXE_SYSTEM),msvc)
  $(PKG)_PREFIX := '$(HOST_PREFIX)/local/$($(PKG)_SUBDIR)'
  # - Enable atomic refcount (required for QtHandles)
  # - Skip configure test for pow and sqrt, MSVC fails to compile them
  #   because it uses intrinsics (with -O2 flag) and bump on the fake
  #   "char FUNC()" forward declaration.
  # - Override CFLAGS and CXXFLAGS to disable some warnings.
  $(PKG)_EXTRA_CONFIGURE_OPTIONS := \
    --enable-atomic-refcount \
    ac_cv_func_pow=yes ac_cv_func_sqrt=yes \
    CFLAGS='-O2 -wd4244 -wd4003 -wd4005 -wd4068' \
    CXXFLAGS='-O2 -wd4244 -wd4003 -wd4005 -wd4068'
else
  $(PKG)_PREFIX := '$(HOST_PREFIX)'
  $(PKG)_EXTRA_CONFIGURE_OPTIONS := \
    LDFLAGS='-Wl,-rpath-link,$(HOST_LIBDIR) -L$(HOST_LIBDIR) -L$($(PKG)_QTDIR)/lib'
endif

ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_EXTRA_CONFIGURE_OPTIONS += --with-x=no
endif

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  $(PKG)_EXTRA_CONFIGURE_OPTIONS += ac_cv_search_tputs=-ltermcap
endif

# if want binary packages and are cross compiling, then we need cross tools enabled
ifeq ($(ENABLE_BINARY_PACKAGES),yes)
  ifeq ($(MXE_NATIVE_BUILD),no)
    $(PKG)_EXTRA_CONFIGURE_OPTIONS += --enable-cross-tools
  endif
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package octave.' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    # jni install
    if [ "$(MXE_SYSTEM)" == "mingw" ] \
      && [ "$(MXE_NATIVE_BUILD)" == "no" ] \
      && [ "$(ENABLE_JAVA)" == "yes" ]; then \
      if [ ! -f $(HOST_INCDIR)/java/jni.h ]; then \
        mkdir -p '$(HOST_INCDIR)/java'; \
        $(WGET) -N http://hg.openjdk.java.net/jdk7u/jdk7u/jdk/raw-file/tip/src/share/javavm/export/jni.h \
          -O $(HOST_INCDIR)/java/jni.h; \
      fi; \
      if [ ! -f $(HOST_INCDIR)/java/win32/jni_md.h ]; then \
        mkdir -p '$(HOST_INCDIR)/java/win32'; \
        $(WGET) -N http://hg.openjdk.java.net/jdk7u/jdk7u/jdk/raw-file/tip/src/windows/javavm/export/jni_md.h \
          -O $(HOST_INCDIR)/java/win32/jni_md.h; \
      fi; \
    fi

    mkdir '$(1)/.build'
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$($(PKG)_PREFIX)' \
        --disable-silent-rules \
        --enable-install-build-logs \
        $($(PKG)_CROSS_CONFIG_OPTIONS) \
        $($(PKG)_WITH_BLAS_CONFIGURE_OPTIONS) \
        $($(PKG)_ENABLE_64_CONFIGURE_OPTIONS) \
        $($(PKG)_ENABLE_FORTRAN_INT64_CONFIGURE_OPTIONS) \
        $($(PKG)_ENABLE_JAVA_CONFIGURE_OPTIONS) \
        $($(PKG)_ENABLE_JIT_CONFIGURE_OPTIONS) \
        $($(PKG)_ENABLE_DOCS_CONFIGURE_OPTIONS) \
        $($(PKG)_QT_CONFIGURE_OPTIONS) \
        $($(PKG)_EXTRA_CONFIGURE_OPTIONS) \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        PKG_CONFIG_PATH=$($(PKG)_PKG_CONFIG_PATH) \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build/libgnu'

    ## We want both of these install steps so that we install in the
    ## location set by the configure --prefix option, and the other
    ## in a directory tree that will have just Octave files.
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'

    if [ "x$(MXE_SYSTEM)" == "xmingw" ]; then \
      $(INSTALL) '$(3)/$(HOST_BINDIR)/libxerbla.dll' '$(3)$(HOST_BINDIR)/libxerbla-octave.dll'; \
      cp '$(1)/.build/src/.libs/octave-gui.exe' '$(3)$(HOST_BINDIR)'; \
      if [ "x$(ENABLE_BINARY_PACKAGES)" == "xyes" ]; then \
        mkdir -p '$(3)$(BUILD_TOOLS_PREFIX)/bin'; \
        $(INSTALL) '$(1)/.build/src/$(MXE_TOOL_PREFIX)mkoctfile' '$(3)$(BUILD_TOOLS_PREFIX)/bin'; \
        $(INSTALL) '$(1)/.build/src/$(MXE_TOOL_PREFIX)octave-config' '$(3)$(BUILD_TOOLS_PREFIX)/bin'; \
      fi; \
    fi

    if [ "x$(ENABLE_DOCS)" == "xyes" ]; then \
        $(MAKE) -C '$(1)/.build' -j '$(JOBS)' DESTDIR=$(3) install-pdf install-html; \
    fi

    if [ $(MXE_SYSTEM) != msvc ]; then \
        $(MAKE) -C '$(1)/.build' -j '$(JOBS)' DESTDIR=$(TOP_BUILD_DIR)/octave install; \
    fi

    # create a file with latest installed octave rev in it
    echo "$($(PKG)_VERSION)" > $(TOP_BUILD_DIR)/octave/octave-version
endef
