# This file is part of MXE.
# See index.html for further information.

PKG             := of-financial
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.2
$(PKG)_CHECKSUM := 7e56690e9cf90fb7d6d837c9f16f32e1bf580ac3
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
