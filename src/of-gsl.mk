# This file is part of MXE.
# See index.html for further information.

PKG             := of-gsl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := 2732fd71d378d1ca97ebec63d824df0f362612d4
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := gsl-$($(PKG)_VERSION)
$(PKG)_FILE     := gsl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := gsl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="gsl-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
