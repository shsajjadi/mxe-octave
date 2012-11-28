# This file is part of MXE.
# See index.html for further information.

PKG             := octave
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1ea936554aaabaabb747a4fcf98ecfbbfb265656
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://jweaton.org/$($(PKG)_FILE)
$(PKG)_DEPS     := blas curl fltk gcc glpk graphicsmagick lapack pcre qrupdate readline suitesparse zlib

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package octave.' >&2;
    echo $(octave_VERSION)
endef

define $(PKG)_BUILD
    # build GCC and support libraries
    mkdir '$(1).build'
    cd '$(1).build' && '$(1)/octave-$($(PKG)_VERSION)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-opengl \
        --disable-docs \
        --disable-gui
    sed -i '/^#define \(gm\|local\)time rpl_/d' '$(1).build/config.h'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install
endef
