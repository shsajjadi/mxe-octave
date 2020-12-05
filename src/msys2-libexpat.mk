# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libexpat
$(PKG)_NAME     := libexpat
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.9-1
$(PKG)_x86_64_CS := 9f03f4f283f25a16c00781fbc4cad602d41f9c47
$(PKG)_i686_CS  := d445da2f656c497e090bb2ea79be2d883a73a740
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
