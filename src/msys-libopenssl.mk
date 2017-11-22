# This file is part of MXE.
# See index.html for further information.

PKG             := msys-libopenssl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0-1
$(PKG)_CHECKSUM := 09bceb768e6989feb5af63928cfda661977bf751
$(PKG)_REMOTE_SUBDIR := openssl/openssl-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := libopenssl-$($(PKG)_VERSION)-msys-1.0.13-dll-100.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/openssl' | \
    $(SED) -n 's,.*title="openssl-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_EXTENSION_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_EXTENSION_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
