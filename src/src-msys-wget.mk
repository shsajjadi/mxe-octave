# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-wget
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12-1
$(PKG)_CHECKSUM := e4302886ab009c825db69917eb6e73bcb481c443
$(PKG)_REMOTE_SUBDIR := wget/wget-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := wget-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/wget' | \
    $(SED) -n 's,.*title="wget-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
