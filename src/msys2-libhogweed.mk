# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libhogweed
$(PKG)_NAME     := libhogweed
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4-1
$(PKG)_x86_64_CS := 783b8bfc1e2721c616b30c82e83372d19a472cae
$(PKG)_i686_CS  := 2352f37afa3de71fe0d4a03d95748f44ea986cbb
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
