# This file is part of MXE.
# See index.html for further information.

PKG             := of-sparsersb
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.8
$(PKG)_CHECKSUM := 0fef69505cb65f04f62a8a6044f7f0653afc995a
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := sparsersb-$($(PKG)_VERSION)
$(PKG)_FILE     := sparsersb-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := librsb

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
    ifeq ($(MXE_NATIVE_BUILD),no)
        ifeq ($(USE_SYSTEM_OCTAVE),no)
            # Remove this when package builds without calling Octave
            $(PKG)_DEPS += build-octave
        endif
    endif
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    cd $(1)/src && ./autogen.sh
    $(OCTAVE_FORGE_PKG_BUILD)
endef
