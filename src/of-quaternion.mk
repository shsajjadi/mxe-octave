# This file is part of MXE.
# See index.html for further information.

PKG             := of-quaternion
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.2
$(PKG)_CHECKSUM := 5fb44e4f2ff5fb7d6dd14e949fc2a909f084be67
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := quaternion
$(PKG)_FILE     := quaternion-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="quaternion-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
