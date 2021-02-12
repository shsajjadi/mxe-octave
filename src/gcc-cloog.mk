# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-cloog
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.18.4
$(PKG)_CHECKSUM := 8f7568ca1873f8d55bb694c8b9b83f7f4c6c1aa5
$(PKG)_SUBDIR   := cloog-$($(PKG)_VERSION)
$(PKG)_FILE     := cloog-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.bastoul.net/cloog/pages/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc-gmp gcc-isl

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $(cloog_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --disable-shared \
        --with-gmp-prefix='$(BUILD_TOOLS_PREFIX)' \
        --with-isl-prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
