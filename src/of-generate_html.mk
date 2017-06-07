# This file is part of MXE.
# See index.html for further information.

PKG             := of-generate_html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.0
$(PKG)_CHECKSUM := fd1c3c1eed5207ec4216c7e72ef00947353d459d
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := generate_html-$($(PKG)_VERSION)
$(PKG)_FILE     := generate_html-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="generate_html-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
