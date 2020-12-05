# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-diffutils
$(PKG)_NAME     := diffutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.7-1
$(PKG)_CHECKSUM := fd20765234e40e5ea0275449e8acee50f30b7edf
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
