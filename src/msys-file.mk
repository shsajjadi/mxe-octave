# This file is part of MXE.
# See index.html for further information.

PKG             := msys-file
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.04-1
$(PKG)_CHECKSUM := 9d38d45a66ff2b72d732397a9e23a12e347ae41f
$(PKG)_REMOTE_SUBDIR := file/file-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := file-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/file' | \
    $(SED) -n 's,.*title="file-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
