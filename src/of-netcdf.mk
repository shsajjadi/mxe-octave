# This file is part of MXE.
# See index.html for further information.

PKG             := of-netcdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.6
$(PKG)_CHECKSUM := f39de6961c3866574735e5556492531c1fde3b1a
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := netcdf
$(PKG)_FILE     := netcdf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := netcdf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="netcdf-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD_NOCOMPILE)
endef
