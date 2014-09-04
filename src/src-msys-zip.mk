# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-zip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0-1
$(PKG)_CHECKSUM := 6f408c4fd59f223828711df748d41cfe55b8ce7c
$(PKG)_REMOTE_SUBDIR := zip/zip-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := zip-$($(PKG)_VERSION)-msys-1.0.14-src.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/zip' | \
    $(SED) -n 's,.*title="zip-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
