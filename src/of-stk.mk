# This file is part of MXE.
# See index.html for further information.

PKG             := of-stk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.0
$(PKG)_CHECKSUM := 8150b990043e92bdf112319e26ffaa6a689a8928
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := stk
$(PKG)_FILE     := stk-$($(PKG)_VERSION).tar.gz
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
