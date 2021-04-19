# This file is part of MXE.
# See index.html for further information.

PKG             := build-ninja
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.10.2
$(PKG)_CHECKSUM := 8d2e8c1c070c27fb9dc46b4a6345bbb1de7ccbaf
$(PKG)_SUBDIR   := ninja-$($(PKG)_VERSION)
$(PKG)_FILE     := ninja-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/ninja-build/ninja/archive/refs/tags/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
  mkdir '$(1)/.build' && cd '$(1)/.build' && cmake .. \
    $($(PKG)_CMAKE_FLAGS) \
    $(CMAKE_CCACHE_FLAGS) \
    -DCMAKE_INSTALL_PREFIX='$(3)$(BUILD_TOOLS_PREFIX)' \
    -DBUILD_TESTING=Off

  cmake --build '$(1)/.build' -j '$(JOBS)'
  cmake --install '$(1)/.build'
endef
