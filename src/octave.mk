# This file is part of MXE.
# See index.html for further information.

PKG             := octave
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 658a079ac498309d5aa5a2556f53a7856fcde938
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://alpha.gnu.org/gnu/octave/$($(PKG)_FILE)
$(PKG)_DEPS     := arpack blas curl fftw fltk gcc glpk gnuplot graphicsmagick lapack llvm pcre qhull qrupdate qscintilla qt readline suitesparse zlib

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package octave.' >&2;
    echo $(octave_VERSION)
endef

define $(PKG)_BUILD
    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libuuid.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libuuid.dll.a' '$(PREFIX)/$(TARGET)/lib/libuuid.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libuuid.dll' '$(PREFIX)/$(TARGET)/bin/libuuid.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libuuid.dll'; \
    fi

    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gui \
        FLTK_CONFIG="$(PREFIX)/bin/$(TARGET)-fltk-config" \
        gl_cv_func_gettimeofday_clobber=no

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build' -j 1 DESTDIR=$(PREFIX)/../octave install
endef
