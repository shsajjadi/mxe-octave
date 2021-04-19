# This file is part of MXE.
# See index.html for further information.

PKG             := curl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.76.1
$(PKG)_CHECKSUM := d38ab79ef7a6d92df91ca8dfcf9a5eaf7e25b725
$(PKG)_SUBDIR   := curl-$($(PKG)_VERSION)
$(PKG)_FILE     := curl-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gnutls libidn2 libssh2 pthreads

$(PKG)_CONFIGURE_OPTS :=
ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_CONFIGURE_OPTS := --with-winssl --with-default-ssl-backend=schannel
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
