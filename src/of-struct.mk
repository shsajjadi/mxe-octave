# This file is part of MXE.
# See index.html for further information.

PKG             := of-struct
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.17
$(PKG)_CHECKSUM := df82c63f13cece4e8dbd1aa9d52b9e8450f6fd09
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := struct-$($(PKG)_VERSION)
$(PKG)_FILE     := struct-$($(PKG)_VERSION).tar.gz
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
