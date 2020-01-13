# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-liblzma
$(PKG)_NAME     := xz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2.4-1
$(PKG)_CHECKSUM := c075ea259097b06f4acbe406ff777a733fa6c67b
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
