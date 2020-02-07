# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libgnutls
$(PKG)_NAME     := libgnutls
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.12-1
$(PKG)_x86_64_CS := c64207f1f31f6905e6f9aea11e82212fc4a489cd
$(PKG)_i686_CS  := 40ca17fc49c23aedc98c480c1126c52b737031c3
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
