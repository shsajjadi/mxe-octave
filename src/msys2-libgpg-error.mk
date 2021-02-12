# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libgpg-error
$(PKG)_NAME     := libgpg-error
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.37-1
$(PKG)_x86_64_CS := 2c93e18b4411b4bec8efedc952190e3ce4d3fbbd
$(PKG)_i686_CS  := 748f1463be555ce8f298767d1113ff20dc82eb22
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
