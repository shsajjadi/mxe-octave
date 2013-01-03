# This file is part of MXE.
# See index.html for further information.

PKG             := octave-stable
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 543d0c9e9a6c5406004b86a803c34711f0cdfcdf
$(PKG)_SUBDIR   := octave-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://alpha.gnu.org/gnu/octave/$($(PKG)_FILE)
$(PKG)_DEPS     := arpack blas curl fftw fltk gcc glpk gnuplot graphicsmagick lapack pcre qhull qrupdate readline suitesparse zlib

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package octave.' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    # build GCC and support libraries
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        FLTK_CONFIG="$(PREFIX)/bin/$(TARGET)-fltk-config" \
        gl_cv_func_gettimeofday_clobber=no

    ## We want both of these install steps so that we install in the
    ## location set by the configure --prefix option, and the other
    ## in a directory tree that will have just Octave files.
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' DESTDIR=$(PREFIX)/../octave-stable install
endef
