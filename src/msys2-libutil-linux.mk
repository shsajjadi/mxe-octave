# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libutil-linux
$(PKG)_NAME     := libutil-linux
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.32.1-1
$(PKG)_x86_64_CS := 5e768cff80fbd19fa942122ac097d1f9c905d70f
$(PKG)_i686_CS  := bcd4925506a18dcfd98358426527e2840ca79a04
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
