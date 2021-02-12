# This file is part of MXE.
# See index.html for further information.

PKG             := of-ocs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.5
$(PKG)_CHECKSUM := 4cb871bcd96e8443e9839525c2721b99957fc75c
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := ocs
$(PKG)_FILE     := ocs-$($(PKG)_VERSION).tar.gz
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
