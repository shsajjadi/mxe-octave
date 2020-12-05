# This file is part of MXE.
# See index.html for further information.

PKG             := of-general
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.1
$(PKG)_CHECKSUM := 56e4c3aca7ad7cfc95aee52f680a2978da9465ad
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := general-$($(PKG)_VERSION)
$(PKG)_FILE     := general-$($(PKG)_VERSION).tar.gz
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
