# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-gzip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.12-2
$(PKG)_CHECKSUM := c76bedc6e1afdb48bf10dd14b5c1986096e25290
$(PKG)_REMOTE_SUBDIR := gzip/gzip-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := gzip-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/gzip' | \
    $(SED) -n 's,.*title="gzip-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
