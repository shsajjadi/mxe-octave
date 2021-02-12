# This file is part of MXE.
# See index.html for further information.

PKG             := of-ltfat
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := 2c87141b877f721e10cbb4a99dca1cb880dce8d8
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := ltfat
$(PKG)_FILE     := ltfat-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := portaudio

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

ifeq ($(MXE_SYSTEM),mingw)
$(PKG)_OPTIONS := OPTCXXFLAGS='-DLTFAT_BUILD_STATIC -DMINGW=1' MINGW=1
else
$(PKG)_OPTIONS := 
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(call OCTAVE_FORGE_PKG_BUILD,$(1),$(2),$(3),$($(PKG)_OPTIONS))
endef
