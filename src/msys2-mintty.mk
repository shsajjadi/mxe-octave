# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-mintty
$(PKG)_NAME     := mintty
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1~3.0.1-1
$(PKG)_x86_64_CS := 04309ab667bf9fd72ffebb8f5d7f62cf3a96da26
$(PKG)_i686_CS  := 207c93aa0772d373454817723eb523fa8748c3d1
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
