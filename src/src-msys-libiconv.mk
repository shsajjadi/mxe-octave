# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-libiconv
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14-1
$(PKG)_CHECKSUM := 564888c41fb3ec4643d440112789504b18543541
$(PKG)_REMOTE_SUBDIR := libiconv/libiconv-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := libiconv-$($(PKG)_VERSION)-msys-1.0.17-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/libiconv' | \
    $(SED) -n 's,.*title="libiconv-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
