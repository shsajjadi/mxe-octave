# This file is part of MXE.
# See index.html for further information.

PKG             := of-io
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.6
$(PKG)_CHECKSUM := bd1c4292b871ad743486317500be4b283629b9a6
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := io
$(PKG)_FILE     := io-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="io-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
