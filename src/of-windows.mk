# This file is part of MXE.
# See index.html for further information.

PKG             := of-windows
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.1
$(PKG)_CHECKSUM := 2270f3d64cf69d030e6825303158c18b9b94a871
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := Windows
$(PKG)_FILE     := windows-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
