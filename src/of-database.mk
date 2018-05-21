# This file is part of MXE.
# See index.html for further information.

PKG             := of-database
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.3
$(PKG)_CHECKSUM := 33b76d2fec629100f1be45f8cbf7a57846842109
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := database-$($(PKG)_VERSION)
$(PKG)_FILE     := database-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

ifeq ($(MXE_SYSTEM)$(MXE_NATIVE_MINGW_BUILD),mingwno)
define $(PKG)_BUILD
    cd '$(1)/src' && source ./bootstrap
    $(OCTAVE_FORGE_PKG_BUILD,$(1),$(2),$(3),"BUILD_CXX=g++"))
endef
else
define $(PKG)_BUILD
    cd '$(1)/src' && source ./bootstrap
    $(OCTAVE_FORGE_PKG_BUILD)
endef
endif
