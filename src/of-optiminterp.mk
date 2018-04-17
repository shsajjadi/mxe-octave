# This file is part of MXE.
# See index.html for further information.

PKG             := of-optiminterp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.5
$(PKG)_CHECKSUM := 071a2a9dd9de1ce3f1928d239604807fb71c4232
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := optiminterp-$($(PKG)_VERSION)
$(PKG)_FILE     := optiminterp-$($(PKG)_VERSION).tar.gz
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
