# This file is part of MXE.
# See index.html for further information.

PKG             := msys-libiconv
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14-1
$(PKG)_CHECKSUM := 056d16bfb7a91c3e3b1acf8adb20edea6fceecdd
$(PKG)_REMOTE_SUBDIR := libiconv/libiconv-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := libiconv-$($(PKG)_VERSION)-msys-1.0.17-dll-2.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/libiconv' | \
    $(SED) -n 's,.*title="libiconv-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
