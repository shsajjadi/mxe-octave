# This file is part of MXE.
# See index.html for further information.

PKG             := nettle
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1061754feb69dd01354525fa7eb6154b28ac887d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.lysator.liu.se/~nisse/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gmp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.lysator.liu.se/~nisse/archive/' | \
    $(SED) -n 's,.*nettle-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'pre' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' getopt.o getopt1.o
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
 \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libnettle.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libnettle.dll.a' '$(PREFIX)/$(TARGET)/lib/libnettle.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libnettle.dll' '$(PREFIX)/$(TARGET)/bin/libnettle.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libnettle.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libnettle.la'; \
 \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libhogweed.a' -lnettle -lgmp; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libhogweed.dll.a' '$(PREFIX)/$(TARGET)/lib/libhogweed.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libhogweed.dll' '$(PREFIX)/$(TARGET)/bin/libhogweed.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libhogweed.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libhogweed.la'; \
    fi
endef
