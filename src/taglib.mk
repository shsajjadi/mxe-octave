# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# TagLib
PKG             := taglib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.3
$(PKG)_CHECKSUM := ee54f10c63f236ef1c29c82e39c227a75a7e3785
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://developer.kde.org/~wheeler/taglib.html
$(PKG)_URL      := http://developer.kde.org/~wheeler/files/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://developer.kde.org/~wheeler/files/src/?C=M;O=D' | \
    $(SED) -n 's,.*"taglib-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i '/#define TAGLIB_EXPORT_H/a#define TAGLIB_STATIC' '$(1)/taglib/taglib_export.h'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
