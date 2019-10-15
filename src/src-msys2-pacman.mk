# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-pacman
$(PKG)_NAME     := pacman
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.3-5
$(PKG)_CHECKSUM := cd35fed8428c2a537bd1cb5814dd89a855b70c60
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
