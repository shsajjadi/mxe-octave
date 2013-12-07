# This file is part of MXE.
# See index.html for further information.

PKG             := libharu
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b75ec6052b8d72aa7f23d67adcdf9df4847b64ca
$(PKG)_SUBDIR   := libharu-$($(PKG)_VERSION)
$(PKG)_FILE     := libharu-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://libharu.org/files/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib libpng

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://libharu.org/files/?C=M;O=D' | \
    $(SED) -n 's,.*libharu-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'rc' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --with-zlib='$(HOST_PREFIX)' \
        --with-png='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
