# This file is part of MXE.
# See index.html for further information.

PKG             := of-image
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.2
$(PKG)_CHECKSUM := ed119962e8bfc765f786758b082f070d50959107
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := image
$(PKG)_FILE     := image-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := of-signal

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="image-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD_NOCOMPILE)
endef
