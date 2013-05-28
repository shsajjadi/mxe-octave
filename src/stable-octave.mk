# This file is part of MXE.
# See index.html for further information.

PKG             := stable-octave
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 4563c3fdb15ac76419f78b8ad8a9b1ba3484a7aa
$(PKG)_SUBDIR   := octave-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/octave/$($(PKG)_FILE)
$(PKG)_DEPS     := arpack blas curl fftw fltk fontconfig gcc glpk gnuplot graphicsmagick hdf5 lapack pcre pstoedit qhull qrupdate readline suitesparse texinfo zlib

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package octave.' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
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
