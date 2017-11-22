# This file is part of MXE.
# See index.html for further information.

PKG             := of-ltfat
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.0
$(PKG)_CHECKSUM := ee330536fc126cc2f32d30074f8e4e641f0a070c
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := ltfat
$(PKG)_FILE     := ltfat-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := portaudio

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
