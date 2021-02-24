# This file is part of MXE.
# See index.html for further information.

PKG             := of-splines
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.4
$(PKG)_CHECKSUM := 47295983e9fc0a6c9fd91167f404c1d1b4f7cb6a
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
