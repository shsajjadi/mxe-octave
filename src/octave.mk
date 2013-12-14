# This file is part of MXE.
# See index.html for further information.

PKG             := octave
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 030648fde42548f28a33e8bad0a281a4dd1141c8
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://alpha.gnu.org/gnu/octave/$($(PKG)_FILE)
ifeq ($(USE_SYSTEM_FONTCONFIG),no)
  $(PKG)_FONTCONFIG := fontconfig
endif
$(PKG)_DEPS     := arpack curl fftw fltk $($(PKG)_FONTCONFIG) gl2ps glpk gnuplot graphicsmagick hdf5 lapack pcre pstoedit qhull qrupdate qscintilla qt readline suitesparse texinfo zlib
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
	--with-java-homedir="$(HOST_INCDIR)/java" \
    	--with-java-includedir="$(HOST_INCDIR)/java"
     endif
  endif
endif

ifeq ($(ENABLE_DOCS),yes)
  $(PKG)_ENABLE_DOCS_CONFIGURE_OPTIONS := --enable-docs
endif

ifeq ($(ENABLE_OPENBLAS),yes)
  $(PKG)_DEPS += openblas
  $(PKG)_BLAS_OPTION := --with-blas=openblas
else
  $(PKG)_DEPS += blas
endif

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_ENV := LD_LIBRARY_PATH=$(LD_LIBRARY_PATH)
  ifeq ($(ENABLE_64),yes)
    $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := --enable-64
  endif
else
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CROSS_CONFIG_OPTIONS := \
      FLTK_CONFIG='$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)fltk-config' \
      gl_cv_func_gettimeofday_clobber=no
    ifeq ($(ENABLE_64),yes)
      $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := --enable-64 ax_blas_f77_func_ok=yes
    endif
  endif
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
    LDFLAGS='-Wl,-rpath-link,$(HOST_LIBDIR) -L$(HOST_LIBDIR)'
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package octave.' >&2;
    echo $(octave_VERSION)
endef

define $(PKG)_BUILD

    # jni install
    if [[ "$(MXE_SYSTEM)" == "mingw" && "$(MXE_NATIVE_BUILD)" == "no" ]]; then \
      mkdir -p '$(HOST_INCDIR)/java/include'; \
      $(WGET) -N http://hg.openjdk.java.net/jdk7u/jdk7u/jdk/raw-file/tip/src/share/javavm/export/jni.h \
        -O $(HOST_INCDIR)/java/include/jni.h; \
      mkdir -p '$(HOST_INCDIR)/java/include/win32'; \
      $(WGET) -N http://hg.openjdk.java.net/jdk7u/jdk7u/jdk/raw-file/tip/src/windows/javavm/export/jni_md.h \
        -O $(HOST_INCDIR)/java/include/win32/jni_md.h; \
    fi

    mkdir '$(1)/.build'
    cd '$(1)' && autoreconf -W none
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$($(PKG)_PREFIX)' \
        $($(PKG)_BLAS_OPTION) \
        $($(PKG)_CROSS_CONFIG_OPTIONS) \
        $($(PKG)_ENABLE_64_CONFIGURE_OPTIONS) \
        $($(PKG)_ENABLE_JAVA_CONFIGURE_OPTIONS) \
        $($(PKG)_ENABLE_JIT_CONFIGURE_OPTIONS) \
        $($(PKG)_ENABLE_DOCS_CONFIGURE_OPTIONS) \
        $($(PKG)_EXTRA_CONFIGURE_OPTIONS) \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' \
        && $(CONFIGURE_POST_HOOK)

    ## We want both of these install steps so that we install in the
    ## location set by the configure --prefix option, and the other
    ## in a directory tree that will have just Octave files.
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'

    if [ "x$(ENABLE_DOCS)" == "xyes" ]; then \
        $(MAKE) -C '$(1)/.build' -j '$(JOBS)' DESTDIR=$(3) install-pdf install-html; \
    fi

    if [ $(MXE_SYSTEM) != msvc ]; then \
        $(MAKE) -C '$(1)/.build' -j '$(JOBS)' DESTDIR=$(TOP_DIR)/octave install; \
    fi
endef

