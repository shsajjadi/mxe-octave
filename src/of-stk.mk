# This file is part of MXE.
# See index.html for further information.

PKG             := of-stk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.4
$(PKG)_CHECKSUM := 29ddba4a54cda15d265976a0cbcd87ca79a32ae1
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := stk
$(PKG)_FILE     := stk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="stk-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
