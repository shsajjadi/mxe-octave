# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libpcre
$(PKG)_NAME     := libpcre
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.43-2
$(PKG)_x86_64_CS := c027408862b0d12fa2d91395626c9cca14524889
$(PKG)_i686_CS  := 214e48b4027d9ae9a72748fb06093f1d5c7823ac
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
