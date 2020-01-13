# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-gmp
$(PKG)_NAME     := gmp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.1.2-1
$(PKG)_CHECKSUM := 929db64b7821951819cdded78f4f91e4c89a8190
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
