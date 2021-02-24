# This file is part of MXE.
# See index.html for further information.

PKG             := of-instrument-control
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.0
$(PKG)_CHECKSUM := b2d6c091dccea01389c51a9279b385135ce035d6
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := instrument-control-$($(PKG)_VERSION)
$(PKG)_FILE     := instrument-control-$($(PKG)_VERSION).tar.gz
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
