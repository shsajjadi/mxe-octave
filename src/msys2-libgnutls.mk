# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libgnutls
$(PKG)_NAME     := libgnutls
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.13-1
$(PKG)_x86_64_CS := bbfff49c947b1ee7b52d5b53f1421647e6280b7e
$(PKG)_i686_CS  := c30b75a31d19f1fe4e06d9b8f235c9be82e19d01
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
