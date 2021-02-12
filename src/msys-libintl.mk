# This file is part of MXE.
# See index.html for further information.

PKG             := msys-libintl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.1.1-1
$(PKG)_CHECKSUM := 4000b935a5bc30b4c757fde69d27716fa3c2c269
$(PKG)_REMOTE_SUBDIR := gettext/gettext-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := libintl-$($(PKG)_VERSION)-msys-1.0.17-dll-8.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/gettext' | \
    $(SED) -n 's,.*title="gettext-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
