# This file is part of MXE.
# See index.html for further information.

PKG             := of-queueing
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.3
$(PKG)_CHECKSUM := 72150daf891b0af0d02c690cf462e219dd2f564d
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := queueing
$(PKG)_FILE     := queueing-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="queueing-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
