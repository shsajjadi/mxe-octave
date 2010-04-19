# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# cURL
PKG             := curl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.20.1
$(PKG)_CHECKSUM := bc3ba6d83069ef1f13d320f29b26f1c63f6056b3
$(PKG)_SUBDIR   := curl-$($(PKG)_VERSION)
$(PKG)_FILE     := curl-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://curl.haxx.se/libcurl/
$(PKG)_URL      := http://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libidn

define $(PKG)_UPDATE
    wget -q -O- 'http://curl.haxx.se/changes.html' | \
    $(SED) -n 's,.*Fixed in \([0-9][^ ]*\) - .*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i '/^#endif/ i#define CURL_STATICLIB' '$(1)/include/curl/curlbuild.h.in'
    $(SED) -i 's,GNUTLS_ENABLED = 1,GNUTLS_ENABLED=1,' '$(1)/configure'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gnutls='$(PREFIX)/$(TARGET)' \
        --with-libidn='$(PREFIX)/$(TARGET)' \
        LIBS="-lgcrypt -liconv `$(PREFIX)/$(TARGET)/bin/gpg-error-config --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
