# This file is part of MXE.
# See index.html for further information.

PKG             := of-struct
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 4703b20612c9e5ec48765af15c28e7a1fc90d427
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := struct-$($(PKG)_VERSION).tar.gz
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
