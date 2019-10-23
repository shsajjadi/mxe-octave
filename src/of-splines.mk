# This file is part of MXE.
# See index.html for further information.

PKG             := of-splines
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.3
$(PKG)_CHECKSUM := a817b1ac1fa6d5715b10754ddf7f51bafc6edf44
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := splines-$($(PKG)_VERSION)
$(PKG)_FILE     := splines-$($(PKG)_VERSION).tar.gz
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
