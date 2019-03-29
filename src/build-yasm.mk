# This file is part of MXE.
# See index.html for further information.

PKG             := build-yasm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.0
$(PKG)_CHECKSUM := b7574e9f0826bedef975d64d3825f75fbaeef55e
$(PKG)_SUBDIR   := yasm-$($(PKG)_VERSION)
$(PKG)_FILE     := yasm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.tortall.net/projects/yasm/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo $(yasm_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --disable-nls \
        --disable-python
    $(MAKE) -C '$(1).build' -j '$(JOBS)' 
    $(MAKE) -C '$(1).build' -j 1 install DESTDIR='$(3)'
endef
