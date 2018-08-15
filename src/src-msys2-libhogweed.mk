# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libhogweed
$(PKG)_NAME     := nettle
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4-1
$(PKG)_CHECKSUM := 8aacf01b73e3e2f5dc90a2acb43932b3688081b5
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
