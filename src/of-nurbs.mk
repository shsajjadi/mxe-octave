# This file is part of MXE.
# See index.html for further information.

PKG             := of-nurbs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.10
$(PKG)_CHECKSUM := 92ae4351cbd61df0246822c5464968267712576e
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := nurbs
$(PKG)_FILE     := nurbs-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     :=
ifeq ($(USE_SYSTEM_GCC),no)
  $(PKG)_DEPS += libgomp
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="nurbs-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
