# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-gcc-libs
$(PKG)_NAME     := gcc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.1.0-2
$(PKG)_CHECKSUM := 10cac3a8252f5801029cdb802e07dc1d1137ae28
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
