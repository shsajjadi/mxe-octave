# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-mintty
$(PKG)_NAME     := mintty
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1~3.0.0-2
$(PKG)_x86_64_CS := 0983a1f6ab7fbb7804d063423f2b876d227e4c20
$(PKG)_i686_CS  := 5cd863aaeff354ce96621f7b8b4ce02c86a91201
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
