# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-pacman-mirrors
$(PKG)_NAME     := pacman-mirrors
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20200307-1
# the mirror package is the same for both systems
$(PKG)_x86_64_CS := 06583c1512e0422a8210d4ed69ed93526874fafd
$(PKG)_CS       := $($(PKG)_x86_64_CS)
$(PKG)_CHECKSUM := $($(PKG)_CS)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION)-any.pkg.tar.xz
$(PKG)_URL      := $(MSYS2_URL)/$($(PKG)_FILE)

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(MSYS2_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(MSYS2_PKG_BUILD)
endef
