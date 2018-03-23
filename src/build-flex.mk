# This file is part of MXE.
# See index.html for further information.

PKG             := build-flex
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 2.6.4
$(PKG)_CHECKSUM := ec5653f673ec8f6e3f07d5e730008cee54d2ce02
$(PKG)_SUBDIR   := flex-$($(PKG)_VERSION)
$(PKG)_FILE     := flex-$($(PKG)_VERSION).tar.lz
$(PKG)_URL      := https://github.com/westes/flex/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := build-lzip

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/westes/flex/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

$(PKG)_CONFIGURE_OPTIONS := ac_cv_func_reallocarray=no

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' $($(PKG)_CONFIGURE_OPTIONS) \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
