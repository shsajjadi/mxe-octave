# This file is part of MXE.
# See index.html for further information.

PKG             := msys-less
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 436-2
$(PKG)_CHECKSUM := 30373c5a85ebd9846e84aed5e147ced56b1e685c
$(PKG)_REMOTE_SUBDIR := less/less-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := less-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/less' | \
    $(SED) -n 's,.*title="less-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
