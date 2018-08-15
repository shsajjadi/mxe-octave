# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libidn2
$(PKG)_NAME     := libidn2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.5-1
$(PKG)_x86_64_CS := 9f7a52fc06e18b320ae4b17c7b587b7731cbb145
$(PKG)_i686_CS  := 5b6ff3f5cc48db72168fa2847efa1ab9fd13469e
$(PKG)_CS       := $($(PKG)_$(MSYS2_ARCH)_CS)
$(PKG)_CHECKSUM := $($(PKG)_CS)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION)-$(MSYS2_ARCH).pkg.tar.xz
$(PKG)_URL      := $(MSYS2_URL)/$($(PKG)_FILE)/download

#https://sourceforge.net/projects/msys2/files/REPOS/MSYS2/x86_64/bash-4.4.019-3-x86_64.pkg.tar.xz/download

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS2_BASE_URL)/' | \
    $(SED) -n 's,.*title="$($(PKG)_NAME)-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(MSYS2_PKG_BUILD)
endef
