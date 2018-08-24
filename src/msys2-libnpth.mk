# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libnpth
$(PKG)_NAME     := libnpth
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5-1
$(PKG)_x86_64_CS := a376962e506ffa05e057726a9521f2be35693c76
$(PKG)_i686_CS  := d6e6c94c198da9efc0d230ead2dde6ea8fc2d1f3
$(PKG)_CS       := $($(PKG)_$(MSYS2_ARCH)_CS)
$(PKG)_CHECKSUM := $($(PKG)_CS)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION)-$(MSYS2_ARCH).pkg.tar.xz
$(PKG)_URL      := $(MSYS2_URL)/$($(PKG)_FILE)/download

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(MSYS2_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(MSYS2_PKG_BUILD)
endef
