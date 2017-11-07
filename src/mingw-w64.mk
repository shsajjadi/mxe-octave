# This file is part of MXE.
# See index.html for further information.

PKG             := mingw-w64
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.2
$(PKG)_CHECKSUM := bb5409f034abb7c021b3e1c14db433fd253cbb59
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/' | \
    $(SED) -n 's,.*mingw-w64-v\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).headers-build'
    cd '$(1).headers-build' && '$(1)/mingw-w64-headers/configure' \
        --host='$(TARGET)' \
        --prefix='$(HOST_PREFIX)' \
        --enable-sdk=all \
        --enable-secure-api

    $(MAKE) -C '$(1).headers-build' install
endef
