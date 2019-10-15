# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libreadline
$(PKG)_NAME     := libreadline
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.0.001-1
$(PKG)_x86_64_CS := a493760308d328c1d79b4d349a31f5b2d1a93e20
$(PKG)_i686_CS  := 9d45e2c75a98b4788ce3759b3f4dba86f1ee7d6e
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
