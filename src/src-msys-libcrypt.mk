# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-libcrypt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1_1-3
$(PKG)_CHECKSUM := e64066bce6e644348903f9b588e1d7613f625fe7
$(PKG)_REMOTE_SUBDIR := crypt/crypt-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := crypt-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/crypt' | \
    $(SED) -n 's,.*title="crypt-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
