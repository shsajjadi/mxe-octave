# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libreadline
$(PKG)_NAME     := readline
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.0.000-1
$(PKG)_CHECKSUM := cdfba3b3689f5169658537e22ce7bde995eb2383
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
