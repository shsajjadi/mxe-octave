# This file is part of MXE.
# See index.html for further information.

PKG             := of-tsa
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.4.5
$(PKG)_CHECKSUM := b2d13fdfac29d360932144e726129359c1c6adf4
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := tsa-$($(PKG)_VERSION)
$(PKG)_FILE     := tsa-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     :=
ifeq ($(USE_SYSTEM_GCC),no)
  $(PKG)_DEPS += libgomp
endif
ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
