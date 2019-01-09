# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-gawk
$(PKG)_NAME     := gawk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.1-2
$(PKG)_CHECKSUM := a858b9f3f824bdb0ca8e6297a1842ba47ec3640d
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
