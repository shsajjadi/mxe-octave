# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-info
$(PKG)_NAME     := info
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.5-2
$(PKG)_x86_64_CS := f1f2c55e12c5a89a43eb22094c3b8aca8a04930c
$(PKG)_i686_CS  := b53ec634836a83338826ade33b543523b7306a34
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
