# This file is part of MXE.
# See index.html for further information.

PKG             := of-ga
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.1
$(PKG)_CHECKSUM := bfa862743f793747281004123411c2c7800b8a50
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := ga-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
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
