# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libnettle
$(PKG)_NAME     := libnettle
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.1-1
$(PKG)_x86_64_CS := b6a54d06d95ac73224ea6be5800d15f4db9f68b9
$(PKG)_i686_CS  := 58eb46dbdf482c9f22a1a87ea68bda2c85e6f3ae
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
