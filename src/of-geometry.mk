# This file is part of MXE.
# See index.html for further information.

PKG             := of-geometry
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := 1189f3989b1c370c4c638410bc53b79e6c4a1e28
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := geometry-$($(PKG)_VERSION)
$(PKG)_FILE     := geometry-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="geometry-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef

