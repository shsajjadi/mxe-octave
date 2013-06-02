# This file is part of MXE.
# See index.html for further information.

PKG             := of-specfun
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 293a98dc2139057aa7119f3065d501616431c6a5
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := specfun-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(HOST_PREFIX)/src'
    $(INSTALL) -m644 '$(PKG_DIR)/$($(PKG)_FILE)' '$(HOST_PREFIX)/src'
endef
