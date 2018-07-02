# This file is part of MXE.
# See index.html for further information.

PKG             := of-interval
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.0
$(PKG)_CHECKSUM := 9890115852745616ec5ca157aec518243d5b8030
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := interval-$($(PKG)_VERSION)
$(PKG)_FILE     := interval-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     :=
ifeq ($(USE_SYSTEM_GCC),no)
  $(PKG)_DEPS += mpfr
endif

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

ifeq ($(MXE_NATIVE_BUILD),no)
$(PKG)_OPTIONS := CRLIBM_CONFIG_FLAGS='--host=$(TARGET)'
else
$(PKG)_OPTIONS := 
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(call OCTAVE_FORGE_PKG_BUILD,$(1),$(2),$(3),$($(PKG)_OPTIONS))
endef
