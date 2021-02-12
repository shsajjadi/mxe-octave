# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-coreutils
$(PKG)_NAME     := coreutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.32-1
$(PKG)_CHECKSUM := 81058057134411482ea3a983f4302f8e670b5324
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
