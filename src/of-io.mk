# This file is part of MXE.
# See index.html for further information.

PKG             := of-io
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.3
$(PKG)_CHECKSUM := 6ed3e70e3ef108204bff87c9b9d29019b844d273
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := io-$($(PKG)_VERSION)
$(PKG)_FILE     := io-$($(PKG)_VERSION).tar.gz
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
