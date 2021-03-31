# This file is part of MXE.
# See index.html for further information.

PKG             := build-cmake
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.19.7
$(PKG)_CHECKSUM := 225582b2bce63d2fe87ed41fc29e0381dc035967
$(PKG)_SUBDIR   := cmake-$($(PKG)_VERSION)
$(PKG)_FILE     := cmake-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.cmake.org/files/v$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
ifeq ($(USE_SYSTEM_GCC),yes)
  $(PKG)_DEPS   :=
else
  $(PKG)_DEPS   := build-gcc
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.cmake.org/cmake/resources/software.html' | \
    $(SED) -n 's,.*cmake-\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install DESTDIR='$(3)'
endef
