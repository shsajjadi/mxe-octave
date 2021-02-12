# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libassuan
$(PKG)_NAME     := libassuan
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.3-1
$(PKG)_x86_64_CS := 7b53d8b1071d01b23c2757ed7c213538b5713baa
$(PKG)_i686_CS  := 05cad0d103ac09d4562813b82db75c2aa876948b
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
