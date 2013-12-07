# This file is part of MXE.
# See index.html for further information.

PKG             := of-io
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3744a01b45cb8519ba1a5477ab1ce7a16ead889f
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := io
$(PKG)_FILE     := io-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
