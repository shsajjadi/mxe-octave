# This file is part of MXE.
# See index.html for further information.

PKG             := of-symbolic
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.0
$(PKG)_CHECKSUM := 85b8aa1e6644f77207ebd9e75e5c416dca09cb1c
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := symbolic-$($(PKG)_VERSION)
$(PKG)_FILE     := symbolic-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_DEPS += python-sympy
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
