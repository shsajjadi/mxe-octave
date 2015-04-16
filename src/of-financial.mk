# This file is part of MXE.
# See index.html for further information.

PKG             := of-financial
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.0
$(PKG)_CHECKSUM := b49cac5e247904cf7288442a823af74da3a1df18
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := financial
$(PKG)_FILE     := financial-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="financial-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
