# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libmetalink
$(PKG)_NAME     := libmetalink
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.3-2
$(PKG)_CHECKSUM := 94aa7bf7ee7e209e3dc7876b120d11fdcf7f212f
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
