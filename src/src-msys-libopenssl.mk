# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-libopenssl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0-1
$(PKG)_CHECKSUM := d2b4f58d0830acc6145c9149ce7e196f8e5a22f5
$(PKG)_REMOTE_SUBDIR := openssl/openssl-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := openssl-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/openssl' | \
    $(SED) -n 's,.*title="openssl-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
