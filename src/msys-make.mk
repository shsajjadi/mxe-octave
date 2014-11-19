# This file is part of MXE.
# See index.html for further information.

PKG             := msys-make
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.81-3
$(PKG)_CHECKSUM := c7264eb13b05cf2e1a982a3c2619837b96203a27
$(PKG)_REMOTE_SUBDIR := make/make-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := make-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/make' | \
    $(SED) -n 's,.*title="make-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
