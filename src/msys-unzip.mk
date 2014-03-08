# This file is part of MXE.
# See index.html for further information.

PKG             := msys-unzip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.0-1
$(PKG)_CHECKSUM := 38efa45dd20dde43a2911782e796e906a4e9a1cb
$(PKG)_REMOTE_SUBDIR := unzip/unzip-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := unzip-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/unzip' | \
    $(SED) -n 's,.*title="unzip-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_EXTENSION_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_EXTENSION_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
