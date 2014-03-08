# This file is part of MXE.
# See index.html for further information.

PKG             := msys-sed
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.1-2
$(PKG)_CHECKSUM := ced60ab96ab3f713da0d0a570232f2a5f0ec5270
$(PKG)_REMOTE_SUBDIR := sed/sed-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := sed-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/sed' | \
    $(SED) -n 's,.*title="sed-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
