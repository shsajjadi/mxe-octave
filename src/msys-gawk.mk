# This file is part of MXE.
# See index.html for further information.

PKG             := msys-gawk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.7-2
$(PKG)_CHECKSUM := 421ecc23e764ed87291796501189cc92fa905c0d
$(PKG)_REMOTE_SUBDIR := gawk/gawk-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := gawk-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/gawk' | \
    $(SED) -n 's,.*title="gawk-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
