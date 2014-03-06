# This file is part of MXE.
# See index.html for further information.

PKG             := of-netcdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2
$(PKG)_CHECKSUM := 5e90c5a5f4de45c200661b3a86fdb4e040bdc97b
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := netcdf
$(PKG)_FILE     := netcdf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := netcdf

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
