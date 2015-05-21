# This file is part of MXE.
# See index.html for further information.

PKG             := of-odepkg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.5
$(PKG)_CHECKSUM := f8fcaae85b6a132be15ca4683cd2b60d5d028bc7
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := odepkg-$($(PKG)_VERSION)
$(PKG)_FILE     := odepkg-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="odepkg-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
