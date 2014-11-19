# This file is part of MXE.
# See index.html for further information.

PKG             := msys-dos2unix
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.0.3-1
$(PKG)_CHECKSUM := bab553c740877d02311bfc5d0be3acadbcc375d0
$(PKG)_REMOTE_SUBDIR := dos2unix/dos2unix-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := dos2unix-$($(PKG)_VERSION)-msys-1.0.17-bin.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/dos2unix' | \
    $(SED) -n 's,.*title="dos2unix-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_EXTENSION_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_EXTENSION_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
