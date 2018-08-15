# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-tar
$(PKG)_NAME     := tar
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.30-1
$(PKG)_CHECKSUM := 04b2f5f85ee6a98fa18344295d4b2fe2874411e6
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
