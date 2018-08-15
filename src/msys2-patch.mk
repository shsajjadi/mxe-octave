# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-patch
$(PKG)_NAME     := patch
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.6-1
$(PKG)_x86_64_CS := 6429c36b3116948d5268df98cbab6fce8b3dca99
$(PKG)_i686_CS  := 0da1fac9e66d5582f028aa50eb675d33eb5e0ba4
$(PKG)_CS       := $($(PKG)_$(MSYS2_ARCH)_CS)
$(PKG)_CHECKSUM := $($(PKG)_CS)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION)-$(MSYS2_ARCH).pkg.tar.xz
$(PKG)_URL      := $(MSYS2_URL)/$($(PKG)_FILE)/download

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS2_BASE_URL)/' | \
    $(SED) -n 's,.*title="$($(PKG)_NAME)-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(MSYS2_PKG_BUILD)
endef
