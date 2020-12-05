# This file is part of MXE.
# See index.html for further information.

PKG             := of-queueing
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.7
$(PKG)_CHECKSUM := 4f5d6956f9ceb6b612b42aaabcbbaece1eec87fb
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := queueing
$(PKG)_FILE     := queueing-$($(PKG)_VERSION).tar.gz
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
