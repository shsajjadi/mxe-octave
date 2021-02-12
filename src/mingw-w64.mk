# This file is part of MXE.
# See index.html for further information.

PKG             := mingw-w64
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.0
$(PKG)_CHECKSUM := 25940043c4541e3e59608dead9b6f75b5596d606
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
        --enable-idl \
        --enable-secure-api

    $(MAKE) -C '$(1).headers-build' install
endef
