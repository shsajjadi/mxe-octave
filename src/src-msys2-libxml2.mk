# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libxml2
$(PKG)_NAME     := libxml2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.10-4
$(PKG)_CHECKSUM := 217439c1526077d2b9660b9eecfb7e01266b5fc3
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
