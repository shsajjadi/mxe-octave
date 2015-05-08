# This file is part of MXE.
# See index.html for further information.

PKG             := of-splines
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.8
$(PKG)_CHECKSUM := 9b4824aa26b8b49c46fe6937e46a01a25451dcc5
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := splines-$($(PKG)_VERSION)
$(PKG)_FILE     := splines-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="splines-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
