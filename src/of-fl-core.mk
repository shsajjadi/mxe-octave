# This file is part of MXE.
# See index.html for further information.

PKG             := of-fl-core
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0
$(PKG)_CHECKSUM := 15c22155457f2eaf3d2531cd8a652732d9b7ebce
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := fl-core
$(PKG)_FILE     := fl-core-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="fl-core-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD_NOCOMPILE)
endef
