# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libiconv
$(PKG)_NAME     := libiconv
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15-1
$(PKG)_x86_64_CS := 0bb31402720ec5558c3ef4616d7f9303ed650a15
$(PKG)_i686_CS  := 0d556ea6cc7c51ac78003785e5ada0ef3d97eda1
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
