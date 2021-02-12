# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-zlib
$(PKG)_NAME     := zlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.11-1
$(PKG)_x86_64_CS := 37e185e5ae7d42c8c045d82c31dda58affb8bb5f
$(PKG)_i686_CS  := 27fcb9cd872dcc466ce2debcd3c5ebf9e2d82e44
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
