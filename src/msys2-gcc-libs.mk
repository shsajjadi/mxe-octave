# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-gcc-libs
$(PKG)_NAME     := gcc-libs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.4.0-1
$(PKG)_x86_64_CS := d797c7467eba970669b8c62e8a9a965daea9403d
$(PKG)_i686_CS  := 5d5a4dcd3e2862df2ebe5bbdd67525f49af54729
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
