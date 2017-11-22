# This file is part of MXE.
# See index.html for further information.

PKG             := of-sparsersb
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.5
$(PKG)_CHECKSUM := 2f259e2b3993134c6f6552327fd5a5933a83bae6
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := sparsersb-$($(PKG)_VERSION)
$(PKG)_FILE     := sparsersb-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := librsb

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    cd $(1)/src && ./autogen.sh
    $(OCTAVE_FORGE_PKG_BUILD)
endef
