# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libsqlite
$(PKG)_NAME     := sqlite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.21.0-4
$(PKG)_CHECKSUM := fe94aaf88865a83a13611f1b5acab20be21c6c77
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
