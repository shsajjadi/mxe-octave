# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-less
$(PKG)_NAME     := less
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 551-1
$(PKG)_x86_64_CS := 9247cc2e0387cfbdaff1ccb28a045be7444c9454
$(PKG)_i686_CS  := 0eb69e481b6bf89a1a01b0bff2e9289ebaecf26d
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
