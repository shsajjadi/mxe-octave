# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-patch
$(PKG)_NAME     := patch
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.6-1
$(PKG)_CHECKSUM := ddae0b3ee221c8d6e072dbd60a06792048a83205
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
