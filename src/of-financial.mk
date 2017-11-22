# This file is part of MXE.
# See index.html for further information.

PKG             := of-financial
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.0
$(PKG)_CHECKSUM := 81612eb7a5ccbcee22f30edda93586c074b7563f
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := financial-$($(PKG)_VERSION)
$(PKG)_FILE     := financial-$($(PKG)_VERSION).tar.gz
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
