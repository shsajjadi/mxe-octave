# This file is part of MXE.
# See index.html for further information.

PKG             := of-sockets
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c4d4f6bea306dd4d722b3f7d8cf475a9fdd0dbba
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := sockets
$(PKG)_FILE     := sockets-$($(PKG)_VERSION).tar.gz
$(PKG)_FIXED_FILE := sockets-$($(PKG)_VERSION)a.tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
