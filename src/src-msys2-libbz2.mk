# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libbz2
$(PKG)_NAME     := bzip2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.7-1
$(PKG)_CHECKSUM := 10c928ebb2d5435e518e3a198e298ce33d0748de
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
