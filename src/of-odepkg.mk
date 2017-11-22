# This file is part of MXE.
# See index.html for further information.

PKG             := of-odepkg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.5
$(PKG)_CHECKSUM := f8fcaae85b6a132be15ca4683cd2b60d5d028bc7
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := odepkg-$($(PKG)_VERSION)
$(PKG)_FILE     := odepkg-$($(PKG)_VERSION).tar.gz
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
