# This file is part of MXE.
# See index.html for further information.

PKG             := of-tsa
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.4.1
$(PKG)_CHECKSUM := 3f2f6c6ca9e3ac7dec73f9294a18f1b35962a5dc
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := tsa
$(PKG)_FILE     := tsa-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     :=
ifeq ($(USE_SYSTEM_GCC),no)
  $(PKG)_DEPS += libgomp
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="tsa-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
