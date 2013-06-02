# This file is part of MXE.
# See index.html for further information.

PKG             := msys-coreutils
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 54ac256a8f0c6a89f1b3c7758f3703b4e56382be
$(PKG)_REMOTE_SUBDIR := coreutils/coreutils-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := coreutils-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
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
