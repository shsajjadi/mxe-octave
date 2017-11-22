# This file is part of MXE.
# See index.html for further information.

PKG             := of-signal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.2
$(PKG)_CHECKSUM := 74843718f51417f49459384b3f2670b2ba3093ac
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := signal-$($(PKG)_VERSION)
$(PKG)_FILE     := signal-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := of-specfun of-control

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
