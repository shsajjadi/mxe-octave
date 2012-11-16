# This file is part of MXE.
# See index.html for further information.

PKG             := zlib
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 858818fe6d358ec682d54ac5e106a2dd62628e7f
$(PKG)_SUBDIR   := zlib-$($(PKG)_VERSION)
$(PKG)_FILE     := zlib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://zlib.net/$($(PKG)_FILE)
$(PKG)_URL_2    := http://$(SOURCEFORGE_MIRROR)/project/libpng/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://zlib.net/' | \
    $(SED) -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CHOST='$(TARGET)' ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --static

    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    if [ "$(BUILD_SHARED)" = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(1)/libz.a'; \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/'; \
      $(INSTALL) -m644 '$(1)/libz.dll.a' '$(PREFIX)/$(TARGET)/lib/libz.dll.a'; \
      $(INSTALL) -m644 '$(1)/libz.dll' '$(PREFIX)/$(TARGET)/bin/libz.dll'; \
    fi
endef
