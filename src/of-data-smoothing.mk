# This file is part of MXE.
# See index.html for further information.

PKG             := of-data-smoothing
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.0
$(PKG)_CHECKSUM := 28fb1233f0db586bccac9317f0f0eff84bb9842e
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := data-smoothing
$(PKG)_FILE     := data-smoothing-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     := of-optim

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
