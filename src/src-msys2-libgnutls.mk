# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libgnutls
$(PKG)_NAME     := gnutls
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.10-1
$(PKG)_CHECKSUM := 4dba4805841f61737e6801d2b35732a4eaa23faf
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
