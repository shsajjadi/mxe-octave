# This file is part of MXE.
# See index.html for further information.

PKG             := of-tsa
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.7
$(PKG)_CHECKSUM := 80d2faa61c32043bf1edc2c0fa48fe0c00eacd89
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := tsa
$(PKG)_FILE     := tsa-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     := libgomp

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
