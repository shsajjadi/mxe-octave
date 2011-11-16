# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# cURL
PKG             := curl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.23.0
$(PKG)_CHECKSUM := 026cbf70672174f96ac719d96025a505e00e3f6b
$(PKG)_SUBDIR   := curl-$($(PKG)_VERSION)
$(PKG)_FILE     := curl-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://curl.haxx.se/libcurl/
$(PKG)_URL      := http://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libidn libssh2

define $(PKG)_UPDATE
    wget -q -O- 'http://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gnutls \
        --with-libidn \
        --enable-sspi \
        LIBS="-lgcrypt -liconv `$(PREFIX)/$(TARGET)/bin/gpg-error-config --libs` -lssh2"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-curl.exe' \
        `'$(TARGET)-pkg-config' libcurl --cflags --libs`
endef
