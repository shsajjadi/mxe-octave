# This file is part of MXE.
# See index.html for further information.

PKG             := msys-gzip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.12-2
$(PKG)_CHECKSUM := a8954ccefa9732cd16b68e2fb50bfef281465c78
$(PKG)_REMOTE_SUBDIR := gzip/gzip-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := gzip-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
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
