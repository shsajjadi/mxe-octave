# This file is part of MXE.
# See index.html for further information.

PKG             := of-linear-algebra
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.0
$(PKG)_CHECKSUM := 513d69169248c903e57cbf8b6a82e850e377045b
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := linear-algebra
$(PKG)_FILE     := linear-algebra-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="linear-algebra-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD_NOCOMPILE)
endef
