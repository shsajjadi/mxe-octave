# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-icu
$(PKG)_NAME     := icu
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 65.1-1
$(PKG)_CHECKSUM := b3f8ed15b175f003267f906ddc4a0bad303ff2bb
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
