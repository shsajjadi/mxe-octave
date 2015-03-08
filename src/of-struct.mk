# This file is part of MXE.
# See index.html for further information.

PKG             := of-struct
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.11
$(PKG)_CHECKSUM := 6bad5d1459ba6b94d0647fbee45e53d900f82d9c
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := struct-$($(PKG)_VERSION)
$(PKG)_FILE     := struct-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="struct-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
