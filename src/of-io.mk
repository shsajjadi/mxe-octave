# This file is part of MXE.
# See index.html for further information.

PKG             := of-io
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.2
$(PKG)_CHECKSUM := 6dcb18186678ebf89936c9ea9e94737d6bf2d3cc
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := io
$(PKG)_FILE     := io-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
