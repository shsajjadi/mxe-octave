# This file is part of MXE.
# See index.html for further information.

PKG             := build-ninja
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.10.0
$(PKG)_CHECKSUM := 7134bca607e17238d272e281ce1cae05d04be970
$(PKG)_SUBDIR   := ninja-$($(PKG)_VERSION)
$(PKG)_FILE     := ninja-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://codeload.github.com/ninja-build/ninja/tar.gz/v$($(PKG)_VERSION)
$(PKG)_DEPS     := build-python3

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && $(PYTHON3) configure.py --bootstrap

    $(INSTALL) -d '$(3)$(BUILD_TOOLS_PREFIX)/bin'
    $(INSTALL) -m755 '$(1)/ninja' '$(3)$(BUILD_TOOLS_PREFIX)/bin';
endef
