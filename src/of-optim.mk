# This file is part of MXE.
# See index.html for further information.

PKG             := of-optim
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.1
$(PKG)_CHECKSUM := ff65c5341533ebb0c8d5749c3645b13c06ea60ca
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := optim-$($(PKG)_VERSION)
$(PKG)_FILE     := optim-$($(PKG)_VERSION).tar.gz
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
