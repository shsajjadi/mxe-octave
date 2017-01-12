# This file is part of MXE.
# See index.html for further information.

PKG             := of-interval
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := f73289c4e0f46f66ac195a483470909bf54ad213
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := interval-$($(PKG)_VERSION)
$(PKG)_FILE     := interval-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     :=
ifeq ($(USE_SYSTEM_GCC),no)
  $(PKG)_DEPS += mpfr
endif

ifeq ($(MXE_NATIVE_BUILD),no)
$(PKG)_OPTIONS := CRLIBM_CONFIG_FLAGS='--host=$(TARGET)'
else
$(PKG)_OPTIONS := 
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="interval-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(call OCTAVE_FORGE_PKG_BUILD,$(1),$(2),$(3),$($(PKG)_OPTIONS))
endef
