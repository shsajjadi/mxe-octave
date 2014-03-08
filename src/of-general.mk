# This file is part of MXE.
# See index.html for further information.

PKG             := of-general
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.4
$(PKG)_CHECKSUM := 990dbd6f294b91e32b023d9d10673fae74d21795
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := general
$(PKG)_FILE     := general-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="general-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
