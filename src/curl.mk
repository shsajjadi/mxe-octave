# This file is part of MXE.
# See index.html for further information.

PKG             := curl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.53.1
$(PKG)_CHECKSUM := fb57f4a94482a98c8d6aaae5dd7bc7dd9e9e28bf
$(PKG)_SUBDIR   := curl-$($(PKG)_VERSION)
$(PKG)_FILE     := curl-$($(PKG)_VERSION).tar.lzma
$(PKG)_URL      := http://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gnutls libidn2 libssh2

$(PKG)_CONFIGURE_OPTS :=
ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_CONFIGURE_OPTS := "--with-winssl"
endif

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
        $($(PKG)_CONFIGURE_OPTS) \
        --without-ssl \
        --with-gnutls \
        --with-libidn2 \
        --enable-sspi \
        --enable-ipv6 \
        --with-libssh2 && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' DESTDIR='$(3)' $(MXE_DISABLE_DOCS) install
endef
