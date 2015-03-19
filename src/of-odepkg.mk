# This file is part of MXE.
# See index.html for further information.

PKG             := of-odepkg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.4
$(PKG)_CHECKSUM := 74b7e88ad5a104e064c413f077a5e5327741efb4
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := odepkg
$(PKG)_FILE     := odepkg-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="odepkg-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD_NOCOMPILE)
endef
