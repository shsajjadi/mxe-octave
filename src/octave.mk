# This file is part of MXE.
# See index.html for further information.

PKG             := octave
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := ff5d66986789412475d64d8ba2c30714ddfc13c4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://gnu.org/gnu/octave/$($(PKG)_FILE)
$(PKG)_DEPS     := arpack blas curl fftw fltk gcc glpk gnuplot graphicsmagick lapack pcre qhull qrupdate readline suitesparse zlib

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package octave.' >&2;
    echo $(octave_VERSION)
endef

define $(PKG)_BUILD
    # build GCC and support libraries
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-opengl \
        --disable-docs \
        gl_cv_func_gettimeofday_clobber=no

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install
endef
