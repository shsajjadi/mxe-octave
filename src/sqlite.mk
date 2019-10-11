# This file is part of MXE.
# See index.html for further information.

PKG             := sqlite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3300100
$(PKG)_CHECKSUM := 8383f29d53fa1d4383e4c8eb3e087f2ed940a9e0
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.sqlite.org/2019/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.sqlite.org/download.html' | \
    $(SED) -n 's,.*sqlite-autoconf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      mkdir '$(1).native' && cd '$(1).native' && '$(1)/configure' \
        --enable-static --disable-shared \
        --prefix='$(BUILD_TOOLS_PREFIX)' && \
      $(MAKE) -C '$(1).native' -j 1 install; \
    fi
    $(SED) -i 's/^Cflags/#Cflags/;' '$(1)/sqlite3.pc.in'
    cd '$(1)' && autoreconf && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        CFLAGS="-Os -DSQLITE_ENABLE_COLUMN_METADATA" \
        --disable-readline
    $(MAKE) -C '$(1)' -j 1
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'
endef
