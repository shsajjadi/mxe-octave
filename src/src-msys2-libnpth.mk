# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys2-libnpth
$(PKG)_NAME     := npth
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5-1
$(PKG)_CHECKSUM := 7ec36c99e12cc2ef5bb86bb8014005dfdd68593e
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
