# This file is part of MXE.
# See index.html for further information.

PKG             := msys-bash
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.23-1
$(PKG)_CHECKSUM := b6ef3399b8d76b5fbbd0a88774ebc2a90e8af13a
$(PKG)_REMOTE_SUBDIR := bash/bash-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := bash-$($(PKG)_VERSION)-msys-1.0.18-bin.tar.xz
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/bash' | \
    $(SED) -n 's,.*title="bash-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
