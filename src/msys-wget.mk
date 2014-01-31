# This file is part of MXE.
# See index.html for further information.

PKG             := msys-wget
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12-1
$(PKG)_CHECKSUM := b13415e735484d82e81bc648fed52a83323ff993
$(PKG)_REMOTE_SUBDIR := wget/wget-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := wget-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_EXTENSION_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_EXTENSION_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
