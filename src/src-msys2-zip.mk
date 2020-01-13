# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-zip
$(PKG)_NAME     := zip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0-3
$(PKG)_CHECKSUM := fe5d592418617d6f2b8d4d08888f4e9982c3c39e
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
