# This file is part of MXE.
# See index.html for further information.

PKG             := msys-zip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0-1
$(PKG)_CHECKSUM := 38a09ab05f88abd8e31e769a4520b2caea79bfde
$(PKG)_REMOTE_SUBDIR := zip/zip-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := zip-$($(PKG)_VERSION)-msys-1.0.14-bin.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/zip' | \
    $(SED) -n 's,.*title="zip-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_EXTENSION_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_EXTENSION_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
