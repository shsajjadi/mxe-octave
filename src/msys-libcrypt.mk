# This file is part of MXE.
# See index.html for further information.

PKG             := msys-libcrypt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1_1-3
$(PKG)_CHECKSUM := db7933c59e3aa88f38d14faeaa81d79d460d6d3d
$(PKG)_REMOTE_SUBDIR := crypt/crypt-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := libcrypt-$($(PKG)_VERSION)-msys-1.0.13-dll-0.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/crypt' | \
    $(SED) -n 's,.*title="crypt-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_EXTENSION_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_EXTENSION_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
