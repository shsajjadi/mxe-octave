# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libgcrypt
$(PKG)_NAME     := libgcrypt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.3-2
$(PKG)_CHECKSUM := 9d8a6dc8a0dc63a222503f205cbb4678c214f3d9
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := $(MSYS2_SRC_URL)/$($(PKG)_FILE)/download

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS2_BASE_URL)/' | \
    $(SED) -n 's,.*title="$($(PKG)_NAME)-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
