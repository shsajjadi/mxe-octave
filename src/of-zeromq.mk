# This file is part of MXE.
# See index.html for further information.

PKG             := of-zeromq
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.2
$(PKG)_CHECKSUM := 699c3ed9a9c0578fcc394d5287b38464abd65f3e
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := zeromq-$($(PKG)_VERSION)
$(PKG)_FILE     := zeromq-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := zeromq

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
