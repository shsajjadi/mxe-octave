# This file is part of MXE.
# See index.html for further information.

PKG             := of-sockets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 8143ad6e18ce6b64911eedd7c318a34a039ddbd1
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := octave-sockets-$($(PKG)_VERSION)
$(PKG)_FILE     := sockets-$($(PKG)_VERSION).tar.gz
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
