# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-ncurses
$(PKG)_NAME     := ncurses
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.1.20190615-1
$(PKG)_x86_64_CS := d0fea6bd3433f9121ccb877826240e8d21aff28f
$(PKG)_i686_CS  := fc9599210f219c977ffaa47ca210eadd75f9a561
$(PKG)_CS       := $($(PKG)_$(MSYS2_ARCH)_CS)
$(PKG)_CHECKSUM := $($(PKG)_CS)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION)-$(MSYS2_ARCH).pkg.tar.xz
$(PKG)_URL      := $(MSYS2_URL)/$($(PKG)_FILE)

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(MSYS2_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(MSYS2_PKG_BUILD)
endef
