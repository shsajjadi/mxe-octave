# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-zlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.7-1
$(PKG)_CHECKSUM := a65c4635a069fb4fe34146b2ad6f769368401358
$(PKG)_REMOTE_SUBDIR := zlib/zlib-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := zlib-$($(PKG)_VERSION)-msys-1.0.17-src.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/zlib' | \
    $(SED) -n 's,.*title="zlib-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
