# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libnpth
$(PKG)_NAME     := libnpth
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6-1
$(PKG)_x86_64_CS := c2394449c65ebf2df1709c5def7054690e570b0a
$(PKG)_i686_CS  := 3fde6864fe80a41f3fbab805788191acb5d9d5ae
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
