# This file is part of MXE.
# See index.html for further information.

PKG             := of-control
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c99e049fda72300a3e77a763b9c5a00829f91c0f
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := control-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(PREFIX)/$(TARGET)/src'
    $(INSTALL) -m644 '$(PKG_DIR)/$($(PKG)_FILE)' '$(PREFIX)/$(TARGET)/src'
endef
