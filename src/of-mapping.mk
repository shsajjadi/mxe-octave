# This file is part of MXE.
# See index.html for further information.

PKG             := of-mapping
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.0
$(PKG)_CHECKSUM := e26da08449cda32508cdca3225c087060fa0fe16
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := mapping-$($(PKG)_VERSION)
$(PKG)_FILE     := mapping-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := gdal

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
