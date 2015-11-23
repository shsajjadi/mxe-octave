# This file is part of MXE.
# See index.html for further information.

PKG             := of-sparsersb
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0
$(PKG)_CHECKSUM := 
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := sparsersb-$($(PKG)_VERSION)
$(PKG)_FILE     := sparsersb-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := librsb

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="sparsersb-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
