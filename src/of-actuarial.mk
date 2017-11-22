# This file is part of MXE.
# See index.html for further information.

PKG             := of-actuarial
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := 89cc7a697f347329a107676afcf09575faa2f386
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := actuarial
$(PKG)_FILE     := actuarial-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
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
