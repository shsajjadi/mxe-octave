# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-mpdecimal
$(PKG)_NAME     := mpdecimal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.2-2
$(PKG)_CHECKSUM := baf2f04d1502ce51bff4d88a6756bf5bc942f5db
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
