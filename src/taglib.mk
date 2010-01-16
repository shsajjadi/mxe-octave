# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# TagLib
PKG             := taglib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.1
$(PKG)_CHECKSUM := 20d8d95316f084c872e70c9eddc0edd75b75ea09
$(PKG)_SUBDIR   := taglib-$($(PKG)_VERSION)
$(PKG)_FILE     := taglib-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://developer.kde.org/~wheeler/taglib.html
$(PKG)_URL      := http://developer.kde.org/~wheeler/files/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://websvn.kde.org/tags/taglib/?sortby=date' | \
    grep '<a name="' | \
    $(SED) -n 's,.*<a name="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) '/#define TAGLIB_EXPORT_H/a#define TAGLIB_STATIC' -i '$(1)/taglib/taglib_export.h'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
