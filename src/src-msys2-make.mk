# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-make
$(PKG)_NAME     := make
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3-1
$(PKG)_CHECKSUM := b6ba45538bfecb9ac1848b7ef97b713f103eee4e
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
