# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-unzip
$(PKG)_NAME     := unzip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.0-2
$(PKG)_CHECKSUM := c7d77f66763b9836453d46afc810e9e00a9bc2d7
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
