# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libsqlite
$(PKG)_NAME     := sqlite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.27.2-2
$(PKG)_CHECKSUM := 69fd2348bc48623e6b950451532ea531d520862b
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
