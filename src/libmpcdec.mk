# This file is part of MXE.
# See index.html for further information.

PKG             := libmpcdec
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.6
$(PKG)_CHECKSUM := 32139ff5cb43a18f7c99637da76703c63a55485a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://files.musepack.net/source/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://files.musepack.net/source/$(PKG)-$($(PKG)_VERSION)' | \
    $(SED) -n 's,.*$(PKG)-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    grep -v 'beta' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) 
    $(MAKE) -C '$(1)' -j $(JOBS)
    $(MAKE) -C '$(1)' -j 1 install
endef
