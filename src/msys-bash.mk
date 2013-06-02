# This file is part of MXE.
# See index.html for further information.

PKG             := msys-bash
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 2c0d36bcd474a9d1232cfe35aea6f1beb477b78a
$(PKG)_REMOTE_SUBDIR := bash/bash-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := bash-$($(PKG)_VERSION)-msys-1.0.16-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
