# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-info
$(PKG)_NAME     := texinfo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.7-1
$(PKG)_CHECKSUM := 88be67273cd44cc49490d85e1847ec4cccddc26e
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
