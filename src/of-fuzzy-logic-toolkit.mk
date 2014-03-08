# This file is part of MXE.
# See index.html for further information.

PKG             := of-fuzzy-logic-toolkit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.2
$(PKG)_CHECKSUM := 75f9d948ea599c4d214950d3f4d12248ce212827
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := fuzzy-logic-toolkit
$(PKG)_FILE     := fuzzy-logic-toolkit-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="fuzzy-logic-toolkit-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
