# This file is part of MXE.
# See index.html for further information.

PKG             := of-database
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.1
$(PKG)_CHECKSUM := d8c0efac63e695c7d94d6b39c7b8f652e99e3653
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := database-$($(PKG)_VERSION)
$(PKG)_FILE     := database-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="database-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
