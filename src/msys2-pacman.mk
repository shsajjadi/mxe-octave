# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-pacman
$(PKG)_NAME     := pacman
$(PKG)_IGNORE   :=
# NOTE: currently 5.X versions not compatible with our format
$(PKG)_VERSION  := 5.2.1-6
$(PKG)_x86_64_CS := f8525811c2feddcb49801e4652487531dcace21a
$(PKG)_i686_CS  := 9d0a4a2a1dade9968fbb660d003a8fca63411f0d
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
