# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-unzip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.0-1
$(PKG)_CHECKSUM := 2138b68bb3d5215ec67fabbb467db7940e15c168
$(PKG)_REMOTE_SUBDIR := unzip/unzip-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := unzip-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/unzip' | \
    $(SED) -n 's,.*title="unzip-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
