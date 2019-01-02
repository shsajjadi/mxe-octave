# This file is part of MXE.
# See index.html for further information.

PKG             := of-image
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.0
$(PKG)_CHECKSUM := c614fb5c35ea5f4c07ade33d0458ccc9a763b366
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := image-$($(PKG)_VERSION)
$(PKG)_FILE     := image-$($(PKG)_VERSION).tar.gz
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
