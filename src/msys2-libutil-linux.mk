# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libutil-linux
$(PKG)_NAME     := libutil-linux
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.35.1-1
$(PKG)_x86_64_CS := 292e299fff3f0ee848a7683c3b2820ad7ec47431
$(PKG)_i686_CS  := 7f6c875eabad30530de3378522f277f4e8358d59
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
