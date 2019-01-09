# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-coreutils
$(PKG)_NAME     := coreutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.30-1
$(PKG)_CHECKSUM := 4c84071d9d763750f10f794b6a114f8950f9d10a
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
