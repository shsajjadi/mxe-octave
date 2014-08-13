# This file is part of MXE.
# See index.html for further information.

PKG             := of-optim
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.0
$(PKG)_CHECKSUM := d60e6ae879afa5c8542571667d017fef7161d119
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := optim-$($(PKG)_VERSION)
$(PKG)_FILE     := optim-$($(PKG)_VERSION).tar.gz
$(PKG)_FIXED_FILE := optim-$($(PKG)_VERSION)a.tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="optim-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
