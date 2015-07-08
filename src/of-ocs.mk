# This file is part of MXE.
# See index.html for further information.

PKG             := of-ocs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.4
$(PKG)_CHECKSUM := f3aa636a0f63f2c69cc9e0f88fa50c423e0cf548
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := ocs
$(PKG)_FILE     := ocs-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="ocs-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
