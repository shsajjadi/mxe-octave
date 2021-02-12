# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libunistring
$(PKG)_NAME     := libunistring
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.10-1
$(PKG)_CHECKSUM := 5add3e7f5ac3c8491908cdd4461b4de1b681b6e5
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
