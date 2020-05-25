# This file is part of MXE.
# See index.html for further information.

PKG             := sqlite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3320100
$(PKG)_CHECKSUM := 3d34d86ef726b66edeb0b93b2a4c0d036ea8dcf3
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.sqlite.org/2020/$($(PKG)_FILE)
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
    if [ $(MXE_WINDOWS_BUILD) = yes ]; then \
      $(SED) -i 's/^Cflags/#Cflags/;' '$(1)/sqlite3.pc.in'; \
    fi
    cd '$(1)' && autoreconf && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        CFLAGS="-Os -DSQLITE_ENABLE_COLUMN_METADATA" \
        --disable-readline
    $(MAKE) -C '$(1)' -j 1
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
endef
