# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libgnutls
$(PKG)_NAME     := gnutls
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.8-1
$(PKG)_CHECKSUM := f706eb674231d393bcb28ea00556b18545b54641
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
