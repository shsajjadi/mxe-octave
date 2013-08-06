# This file is part of MXE.
# See index.html for further information.

PKG             := octave
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a51f52fa6dfef2e905d0c64f0401caab5a11faca
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://alpha.gnu.org/gnu/octave/$($(PKG)_FILE)
ifeq ($(USE_SYSTEM_FONTCONFIG),no)
  $(PKG)_FONTCONFIG := fontconfig
endif
$(PKG)_DEPS     := arpack curl fftw fltk $($(PKG)_FONTCONFIG) glpk gnuplot graphicsmagick hdf5 lapack pcre pstoedit qhull qrupdate qscintilla qt readline suitesparse texinfo zlib
ifeq ($(ENABLE_JIT),yes)
  $(PKG)_DEPS += llvm
$(PKG)_ENABLE_JIT_CONFIGURE_OPTIONS := --enable-jit
endif

ifeq ($(ENABLE_OPENBLAS),yes)
  $(PKG)_DEPS += openblas
  $(PKG)_BLAS_OPTION := --with-blas=openblas
else
  $(PKG)_DEPS += blas
endif

$(PKG)_CONFIGURE_POST_HOOK := $(CONFIGURE_POST_HOOK) -x

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
  $(PKG)_EXTRA_CONFIGURE_OPTIONS := \
    --enable-atomic-refcount \
    ac_cv_func_pow=yes ac_cv_func_sqrt=yes
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
    mkdir '$(1)/.build'
    cd '$(1)' && autoreconf -W none
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$($(PKG)_PREFIX)' \
        $($(PKG)_BLAS_OPTION) \
	$($(PKG)_CROSS_CONFIG_OPTIONS) \
        $($(PKG)_ENABLE_64_CONFIGURE_OPTIONS) \
        $($(PKG)_ENABLE_JIT_CONFIGURE_OPTIONS) \
	$($(PKG)_EXTRA_CONFIGURE_OPTIONS) \
	PKG_CONFIG='$(MXE_PKG_CONFIG)' \
	PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' \
        && $($(PKG)_CONFIGURE_POST_HOOK)

    ## We want both of these install steps so that we install in the
    ## location set by the configure --prefix option, and the other
    ## in a directory tree that will have just Octave files.
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install
    if [ $(MXE_SYSTEM) != msvc ]; then \
        $(MAKE) -C '$(1)/.build' -j '$(JOBS)' DESTDIR=$(TOP_DIR)/octave install; \
    fi
endef

