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
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-gnutls \
        --with-libidn \
        --enable-sspi \
        --enable-ipv6 \
        --with-libssh2
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

##    '$(TARGET)-gcc' \
##        -W -Wall -Werror -ansi -pedantic \
##        '$(2).c' -o '$(HOST_BINDIR)/test-curl.exe' \
##        `'$(TARGET)-pkg-config' libcurl --cflags --libs`

endef
