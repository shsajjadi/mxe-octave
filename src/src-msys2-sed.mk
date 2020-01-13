# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-sed
$(PKG)_NAME     := sed
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.7-1
$(PKG)_CHECKSUM := 96108be3823381c3b52bbdec2c82b6e0e9ef0a64
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
