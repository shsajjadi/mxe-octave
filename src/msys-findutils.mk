# This file is part of MXE.
# See index.html for further information.

PKG             := msys-findutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.4.2-2
$(PKG)_CHECKSUM := fbdf7bae277f02f4189fa1d9ebf92fba6852dbce
$(PKG)_REMOTE_SUBDIR := findutils/findutils-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := findutils-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/findutils' | \
    $(SED) -n 's,.*title="findutils-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
