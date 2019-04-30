# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libutil-linux
$(PKG)_NAME     := util-linux
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.33.1-1
$(PKG)_CHECKSUM := 975510468331db0d5ec984123a14f0090fe5b234
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
