# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libgnutls
$(PKG)_NAME     := gnutls
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.7.1-1
$(PKG)_CHECKSUM := 7cd81c078aeaa9459b6f8944e4b65c284db2b0b4
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
