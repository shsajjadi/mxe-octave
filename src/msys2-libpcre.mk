# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libpcre
$(PKG)_NAME     := libpcre
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.43-1
$(PKG)_x86_64_CS := c64ab1c4b69290aa95d7da0b04539e0b7ff47917
$(PKG)_i686_CS  := a3b55e1c2b64829e7ed39c4d048377dadb43f0d8
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
