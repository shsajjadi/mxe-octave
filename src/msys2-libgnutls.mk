# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libgnutls
$(PKG)_NAME     := libgnutls
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.8-1
$(PKG)_x86_64_CS := 1b80363f220aa1475e9bf289e09c44e5c863acb9
$(PKG)_i686_CS  := 8e0ad00d35822789de370c0b43293ae3c7cad65d
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
