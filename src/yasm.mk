# This file is part of MXE.
# See index.html for further information.

PKG             := yasm
$(PKG)_VERSION  := 1.3.0
$(PKG)_CHECKSUM := b7574e9f0826bedef975d64d3825f75fbaeef55e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.tortall.net/projects/$(PKG)/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/yasm/yasm/tags' | \
    $(SED) -n 's,.*href="/yasm/yasm/archive/v\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # yasm is always static
    cd '$(1)' && '$(1)/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --disable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' 
    $(MAKE) -C '$(1)' -j 1 install
endef
