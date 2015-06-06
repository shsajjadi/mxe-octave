# This file is part of MXE.
# See index.html for further information.

PKG             := msys-zlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.7-1
$(PKG)_CHECKSUM := 8d381df177ce259153c55a69c7bbbac5daed3e9b
$(PKG)_REMOTE_SUBDIR := zlib/zlib-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := zlib-$($(PKG)_VERSION)-msys-1.0.17-dll.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/zlib' | \
    $(SED) -n 's,.*title="zlib-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_EXTENSION_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_EXTENSION_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
