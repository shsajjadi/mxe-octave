# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-wget
$(PKG)_NAME     := wget
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.20.1-2
$(PKG)_CHECKSUM := e741732e6ca8894848ac1131c02cccfb40a0f57d
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
