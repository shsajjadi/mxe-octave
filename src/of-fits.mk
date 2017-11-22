# This file is part of MXE.
# See index.html for further information.

PKG             := of-fits
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.7
$(PKG)_CHECKSUM := 60b535df86444c9b173dfdafaab58ad4d4eb4274
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := fits-$($(PKG)_VERSION)
$(PKG)_FILE     := fits-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     := pkg-config cfitsio

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
