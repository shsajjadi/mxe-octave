# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libexpat
$(PKG)_NAME     := expat
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.7-1
$(PKG)_CHECKSUM := af38f40f8bbccd371f554322193b334ee1d57eae
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
