# This file is part of MXE.
# See index.html for further information.

PKG             := of-statistics
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.2
$(PKG)_CHECKSUM := 8329abd3da0f75f94e5ea85bb6e51dc16c7d0274
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := statistics-$($(PKG)_VERSION)
$(PKG)_FILE     := statistics-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := of-io

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
    $(OCTAVE_FORGE_PKG_BUILD)
endef
