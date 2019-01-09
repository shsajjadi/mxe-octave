# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-gcc-libs
$(PKG)_NAME     := gcc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.4.0-1
$(PKG)_CHECKSUM := fe01e7d05c334594a4d4eb52bdaaa063cfa5fdf0
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
