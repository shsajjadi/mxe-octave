# This file is part of MXE.
# See index.html for further information.

PKG             := curl
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f75cdcd81ae3cb1eef1b5ff9e736a46cb1d6d2c9
$(PKG)_SUBDIR   := curl-$($(PKG)_VERSION)
$(PKG)_FILE     := curl-$($(PKG)_VERSION).tar.lzma
$(PKG)_URL      := http://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libidn libssh2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gnutls \
        --with-libidn \
        --enable-sspi \
        --enable-ipv6 \
        --with-libssh2
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

##    '$(TARGET)-gcc' \
##        -W -Wall -Werror -ansi -pedantic \
##        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-curl.exe' \
##        `'$(TARGET)-pkg-config' libcurl --cflags --libs`

    if [ "$(BUILD_SHARED)" = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libcurl.a' -lssh2; \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libcurl.dll.a' '$(PREFIX)/$(TARGET)/lib/libcurl.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libcurl.dll' '$(PREFIX)/$(TARGET)/bin/libcurl.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libcurl.dll'; \
    fi
endef
