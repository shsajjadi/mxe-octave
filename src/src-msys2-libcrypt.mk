# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libcrypt
$(PKG)_NAME     := libcrypt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1-2
$(PKG)_CHECKSUM := d8ad56e97e77e1c0e35e5fe7a6650b69861bcc25
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
