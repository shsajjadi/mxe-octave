# This file is part of MXE.
# See index.html for further information.

PKG             := of-control
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.0
$(PKG)_CHECKSUM := ee3f4b1e0ee719d2d877b57905c7e31ef76adcbd
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := control
$(PKG)_FILE     := control-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="control-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
