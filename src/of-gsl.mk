# This file is part of MXE.
# See index.html for further information.

PKG             := of-gsl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.1
$(PKG)_CHECKSUM := 08a29d02d6acd313c793b87614e5d0d4488fbcd1
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := gsl-$($(PKG)_VERSION)
$(PKG)_FILE     := gsl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := gsl

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
