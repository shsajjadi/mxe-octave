# This file is part of MXE.
# See index.html for further information.

PKG             := of-nurbs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.13
$(PKG)_CHECKSUM := ae884f4edf4ee121928ff40e2e06372d2ef8f50a
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := nurbs-$($(PKG)_VERSION)
$(PKG)_FILE     := nurbs-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     :=
ifeq ($(USE_SYSTEM_GCC),no)
  $(PKG)_DEPS += libgomp
endif

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="nurbs-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
