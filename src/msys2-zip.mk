# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-zip
$(PKG)_NAME     := zip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0-3
$(PKG)_x86_64_CS := 4e012405277ad5b3f85d946cff5bebf4bc18c018
$(PKG)_i686_CS  := 31d9ff6d2d4d8e052899fa4dc2aafdfaf9a3c1b8
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
