# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libksba
$(PKG)_NAME     := libksba
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.5-1
$(PKG)_CHECKSUM := e508a3b3f7f084c2b37d8d91bb712239fffd8bc2
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
