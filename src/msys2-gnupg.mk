# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-gnupg
$(PKG)_NAME     := gnupg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.9-1
$(PKG)_x86_64_CS := 666c42be31db07832ca8559ec72c5cefbfc0bc80
$(PKG)_i686_CS  := 9a4e66c72833c804eaf6dbad7f0f59d118700215
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
