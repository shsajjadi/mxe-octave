# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-tar
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.23-1
$(PKG)_CHECKSUM := f65c2f71f8c9c651d0f0b4be84e38205612ea5ee
$(PKG)_REMOTE_SUBDIR := tar/tar-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := tar-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/tar' | \
    $(SED) -n 's,.*title="tar-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
