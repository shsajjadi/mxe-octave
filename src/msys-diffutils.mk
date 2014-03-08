# This file is part of MXE.
# See index.html for further information.

PKG             := msys-diffutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.7.20071206cvs-3
$(PKG)_CHECKSUM := 674d3e0be4c8ffe84290f48ed1dd8eb21bc3f805
$(PKG)_REMOTE_SUBDIR := diffutils/diffutils-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := diffutils-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/diffutils' | \
    $(SED) -n 's,.*title="diffutils-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
