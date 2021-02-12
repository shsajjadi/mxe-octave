# This file is part of MXE.
# See index.html for further information.

PKG             := libpaper
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.28
$(PKG)_CHECKSUM := c6583fbdaebe091d11d81c4e59514e58996f22ba
$(PKG)_SUBDIR   := libpaper-$($(PKG)_VERSION)
$(PKG)_FILE     := libpaper_$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.debian.org/debian/pool/main/libp/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := http://linux.mirrors.es.net/pub/ubuntu/pool/main/libp/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://packages.debian.org/unstable/source/libpaper' | \
    $(SED) -n 's,.*libpaper_\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
