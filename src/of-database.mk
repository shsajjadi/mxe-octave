# This file is part of MXE.
# See index.html for further information.

PKG             := of-database
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.2
$(PKG)_CHECKSUM := cb9654c724012509e2d2e0ceb3ec2c67b20f1eb0
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := database-$($(PKG)_VERSION)
$(PKG)_FILE     := database-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="database-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

ifeq ($(MXE_SYSTEM)$(MXE_NATIVE_MINGW_BUILD),mingwno)
define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD,$(1),$(2),$(3),"BUILD_CXX=g++"))
endef
else
define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
endif
