# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-less
$(PKG)_NAME     := less
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 530-1
$(PKG)_CHECKSUM := 9e0a3c642d027ad2c68f3d13ac2e4d702b56eec9
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
