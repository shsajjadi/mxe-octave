# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libgcrypt
$(PKG)_NAME     := libgcrypt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.3-2
$(PKG)_x86_64_CS := 5e8832ac5171d2b2309c2ec87712017264e20292
$(PKG)_i686_CS  := 278d92efa1db80588ca88e37ee7ddc77da645dd5
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
