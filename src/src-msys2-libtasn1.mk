# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libtasn1
$(PKG)_NAME     := libtasn1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.15.0-1
$(PKG)_CHECKSUM := 6a604ca61b017beab07fbbebb66d808b5e6fa537
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
