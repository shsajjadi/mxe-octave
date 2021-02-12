# This file is part of MXE.
# See index.html for further information.

PKG             := msys-tar
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.23-1
$(PKG)_CHECKSUM := 1791b71ad8573612049a8a4821d93e870fb2ae38
$(PKG)_REMOTE_SUBDIR := tar/tar-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := tar-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/tar' | \
    $(SED) -n 's,.*title="tar-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
