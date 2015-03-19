# This file is part of MXE.
# See index.html for further information.

PKG             := of-communications
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 66ffa1bf7a9a6c0642be8ff92f712ab087b47c90
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := communications
$(PKG)_FILE     := communications-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := of-signal

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="communications-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD_NOCOMPILE)
endef
