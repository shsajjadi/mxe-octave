# This file is part of MXE.
# See index.html for further information.

PKG             := of-gsl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := ff83fac134cb13ab25c0833e96d1e5855516e36f
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
