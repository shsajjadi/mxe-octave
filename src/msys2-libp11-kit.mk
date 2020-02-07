# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libp11-kit
$(PKG)_NAME     := libp11-kit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.23.20-1
$(PKG)_x86_64_CS := 19dbf681b45a3aac155c5012c9f59392a47ea037
$(PKG)_i686_CS  := 01cf378e08b2ebb34816e157ec558f64e95a9733
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
