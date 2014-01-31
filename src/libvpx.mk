# This file is part of MXE.
# See index.html for further information.

PKG             := libvpx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := 356af5f770c50cd021c60863203d8f30164f6021
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://webm.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://code.google.com/p/webm/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*libvpx-v\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        CROSS='$(MXE_TOOL_PREFIX)' \
        ./configure \
        --prefix='$(HOST_PREFIX)' \
        --target=x86-win32-gcc \
        --disable-examples \
        --disable-install-docs
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(MXE_RANLIB) $(HOST_LIBDIR)/libvpx.a
endef
