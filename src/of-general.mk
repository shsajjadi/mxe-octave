# This file is part of MXE.
# See index.html for further information.

PKG             := of-general
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.2
$(PKG)_CHECKSUM := 1662d97f0bf1be957e1a30a287d9c0aff7b5ecdd
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := general
$(PKG)_FILE     := general-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
