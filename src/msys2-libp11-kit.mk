# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libp11-kit
$(PKG)_NAME     := libp11-kit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.23.14-1
$(PKG)_x86_64_CS := 3383f0996454812bc293e2d78d8385ee2702a6c2
$(PKG)_i686_CS  := c3c6972f9dff75f50513350aa42fc6fd1da5600f
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
