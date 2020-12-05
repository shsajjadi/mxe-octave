# This file is part of MXE.
# See index.html for further information.

# NOTE: octcdf is now depreciated - use of netcdf is encouraged instead

PKG             := of-octcdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.10
$(PKG)_CHECKSUM := 96efa6d45fe79480d7de090e759f19d8324cfd21
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := octcdf
$(PKG)_FILE     := octcdf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := netcdf

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
