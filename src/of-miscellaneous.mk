# This file is part of MXE.
# See index.html for further information.

PKG             := of-miscellaneous
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := eec920357a581f26b2bc9079e32732b77c3a641b
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := miscellaneous
$(PKG)_FILE     := miscellaneous-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := of-general units

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
