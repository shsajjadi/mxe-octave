# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-libintl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.1.1-1
$(PKG)_CHECKSUM := 1829b35db16d223f2a74b85058855f26c829eadd
$(PKG)_REMOTE_SUBDIR := gettext/gettext-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := gettext-$($(PKG)_VERSION)-msys-1.0.17-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/gettext' | \
    $(SED) -n 's,.*title="gettext-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
