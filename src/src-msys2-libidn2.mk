# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libidn2
$(PKG)_NAME     := libidn2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.5-1
$(PKG)_CHECKSUM := 231871d6a09484f0ff3555fb0e216c4102567c74
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
