# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-ncurses
$(PKG)_NAME     := ncurses
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.1.20191228-1
$(PKG)_x86_64_CS := 6d307be2fb64469b811eb401f66c21427ec8482a
$(PKG)_i686_CS  := af0d603285f6bedcb08e6fadc250fe4a9f4be9a4
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
