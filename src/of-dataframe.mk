# This file is part of MXE.
# See index.html for further information.

PKG             := of-dataframe
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 3d00ea119d3f9e0bf75b148858f7994b4210eb2d
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := dataframe-$($(PKG)_VERSION)
$(PKG)_FILE     := dataframe-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
