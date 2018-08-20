# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-perl
$(PKG)_NAME     := perl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.24.4-1
$(PKG)_CHECKSUM := 4d7b7b3c72f3a50dd459d596d2afe67098095a3c
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
