# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libbz2
$(PKG)_NAME     := libbz2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.7-1
$(PKG)_x86_64_CS := 71183290fe6b8f0cc3d1899ea26bb789afbccea1
$(PKG)_i686_CS  := 269c807a7915a39c868ba7ccd4fe3b4270dcd18c
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
