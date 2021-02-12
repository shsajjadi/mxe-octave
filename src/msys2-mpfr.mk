# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-mpfr
$(PKG)_NAME     := mpfr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.2-1
$(PKG)_x86_64_CS := 7d5b3fa6860878ce6f7289aeabd8fb4a9b47d639
$(PKG)_i686_CS  := 2ed5eed28cd54e7b7b318383915178438123c7a4
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
