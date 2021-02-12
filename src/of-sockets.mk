# This file is part of MXE.
# See index.html for further information.

PKG             := of-sockets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.1
$(PKG)_CHECKSUM := c3b62b8bca66c992d8f383b69e3094f02ea45dd8
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := sockets-$($(PKG)_VERSION)
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
