# This file is part of MXE.
# See index.html for further information.

PKG             := of-nurbs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.9
$(PKG)_CHECKSUM := 4727f2e38486bdc8452d7657094fbdb7a3980ba5
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := nurbs
$(PKG)_FILE     := nurbs-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := libgomp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="nurbs-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
