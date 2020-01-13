# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libopenssl
$(PKG)_NAME     := openssl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.1.d-1
$(PKG)_CHECKSUM := 89784afbe6479ffa46bb2c85b48d3bf0e58bca87
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := $(MSYS2_SRC_URL)/$($(PKG)_FILE)

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS2_BASE_URL)/' | \
    $(SED) -n 's,.*title="$($(PKG)_NAME)-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
