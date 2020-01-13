# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libpcre
$(PKG)_NAME     := pcre
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.43-2
$(PKG)_CHECKSUM := 7c2f8190c233ef3264f3e62092f1d90623ab01e0
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := $(MSYS2_SRC_URL)/$($(PKG)_FILE)

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS2_BASE_URL)/' | \
    $(SED) -n 's,.*title="$($(PKG)_NAME)-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
