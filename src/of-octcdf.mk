# This file is part of MXE.
# See index.html for further information.

# NOTE: octcdf is now depreciated - use of netcdf is encouraged instead

PKG             := of-octcdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.10
$(PKG)_CHECKSUM := 96efa6d45fe79480d7de090e759f19d8324cfd21
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := octcdf
$(PKG)_FILE     := octcdf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := netcdf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="octcdf-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
