# This file is part of MXE.
# See index.html for further information.

PKG             := of-optim
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.0
$(PKG)_CHECKSUM := b7b55449a2861f0d318db1ccf1c37294fcdca604
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := optim-$($(PKG)_VERSION)
$(PKG)_FILE     := optim-$($(PKG)_VERSION).tar.gz
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
