# This file is part of MXE.
# See index.html for further information.

PKG             := of-nan
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.0
$(PKG)_CHECKSUM := 308067242050f21e67c7b9a482705a710531eb82
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := NaN
$(PKG)_FILE     := nan-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="nan-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
