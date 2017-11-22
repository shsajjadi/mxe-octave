# This file is part of MXE.
# See index.html for further information.

PKG             := of-quaternion
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.0
$(PKG)_CHECKSUM := f02927157927ec4939970fb7be72c9bef76bf4f3
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := quaternion
$(PKG)_FILE     := quaternion-$($(PKG)_VERSION).tar.gz
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
