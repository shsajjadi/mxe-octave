# This file is part of MXE.
# See index.html for further information.

PKG             := of-lssa
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.3
$(PKG)_CHECKSUM := 3ad6f43d0dcdd4c38c33653f1f384056b942d1fe
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := lssa-$($(PKG)_VERSION)
$(PKG)_FILE     := lssa-$($(PKG)_VERSION).tar.gz
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
