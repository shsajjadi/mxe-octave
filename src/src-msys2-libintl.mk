# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libintl
$(PKG)_NAME     := gettext
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.19.8.1-1
$(PKG)_CHECKSUM := 2f5333778765ac2c616da3a1f13c327c54b87085
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
