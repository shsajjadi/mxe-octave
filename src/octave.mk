# This file is part of MXE.
# See index.html for further information.

PKG             := octave
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a51f52fa6dfef2e905d0c64f0401caab5a11faca
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://alpha.gnu.org/gnu/octave/$($(PKG)_FILE)
$(PKG)_DEPS     := arpack blas curl fftw fltk fontconfig gcc glpk gnuplot graphicsmagick hdf5 lapack llvm pcre pstoedit qhull qrupdate qscintilla qt readline suitesparse texinfo zlib

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_ENV := LD_LIBRARY_PATH="'$(LD_LIBRARY_PATH)'"
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

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package octave.' >&2;
    echo $(octave_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)' && autoreconf -W none
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) \
        LDFLAGS='-Wl,-rpath-link,$(HOST_LIBDIR) -L$(HOST_LIBDIR)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
	$($(PKG)_CROSS_CONFIG_OPTIONS) \
        $($(PKG)_ENABLE_64_CONFIGURE_OPTIONS)

    ## We want both of these install steps so that we install in the
    ## location set by the configure --prefix option, and the other
    ## in a directory tree that will have just Octave files.
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' DESTDIR=$(TOP_DIR)/octave install
endef

