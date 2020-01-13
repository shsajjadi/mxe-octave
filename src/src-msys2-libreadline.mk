# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libreadline
$(PKG)_NAME     := readline
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.0.001-1
$(PKG)_CHECKSUM := d1b75db095ef43479fb36f1baf16e9d34f965c5e
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
