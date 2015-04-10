# This file is part of MXE.
# See index.html for further information.

PKG             := of-instrument-control
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.1
$(PKG)_CHECKSUM := 5365a568c6a9e4295a26a6ab7d612ace590a4f67
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := instrument-control
$(PKG)_FILE     := instrument-control-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="instrument-control-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
