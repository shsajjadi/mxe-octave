# This file is part of MXE.
# See index.html for further information.

PKG             := of-zenity
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.7
$(PKG)_CHECKSUM := bc24b583385a3d4d6f438361334be530e38752c7
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := zenity-$($(PKG)_VERSION)
$(PKG)_FILE     := zenity-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     := 

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
