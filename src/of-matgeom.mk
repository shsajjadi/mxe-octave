# This file is part of MXE.
# See index.html for further information.

PKG             := of-matgeom
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.2
$(PKG)_CHECKSUM := d441454e01d95e2f99535d6dd153948c8ff25a19
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := matgeom-$($(PKG)_VERSION)
$(PKG)_FILE     := matgeom-$($(PKG)_VERSION).tar.gz
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
