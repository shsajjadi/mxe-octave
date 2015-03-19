# This file is part of MXE.
# See index.html for further information.

PKG             := of-control
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.6
$(PKG)_CHECKSUM := 540811b8b749fed24ff8ff752b77b8fa941de56e
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := control
$(PKG)_FILE     := control-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="control-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD_NOCOMPILE)
endef
