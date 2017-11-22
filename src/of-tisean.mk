# This file is part of MXE.
# See index.html for further information.

PKG             := of-tisean
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.3
$(PKG)_CHECKSUM := a2efabaceb420b7bacb5808fc3887352ebe62102
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := tisean-$($(PKG)_VERSION)
$(PKG)_FILE     := tisean-$($(PKG)_VERSION).tar.gz
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
