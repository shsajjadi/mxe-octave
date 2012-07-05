# This file is part of MXE.
# See index.html for further information.

PKG             := liboauth
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a5a957ac1538b23a286de4e39a2c9f98ef4c3c0e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://liboauth.sourceforge.net/pool/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc curl openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://liboauth.sourceforge.net/' | \
    $(SED) -n 's,.*liboauth-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-curl
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-liboauth.exe' \
        `'$(TARGET)-pkg-config' oauth --cflags --libs`
endef
