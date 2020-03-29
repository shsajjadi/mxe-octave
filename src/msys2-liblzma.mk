# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-liblzma
$(PKG)_NAME     := liblzma
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2.5-1
$(PKG)_x86_64_CS := 7b883b8aee58f753b819efc11c087f1ee05d2f05
$(PKG)_i686_CS  := 18cee2a30a1b3e518704c9ced2ebb2a356a1db15
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
