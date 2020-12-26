# This file is part of MXE.
# See index.html for further information.

PKG             := msys-grep
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.4-2
$(PKG)_CHECKSUM := 69d03c4415c55b9617850a4991d0708fbe3788f6
$(PKG)_REMOTE_SUBDIR := grep/grep-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := grep-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/grep' | \
    $(SED) -n 's,.*title="grep-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
