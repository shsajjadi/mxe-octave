# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libgpg-error
$(PKG)_NAME     := libgpg-error
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.32-1
$(PKG)_x86_64_CS := 0a3c859ffae677def22613fb35c74c881f1fcbaa
$(PKG)_i686_CS  := 8de25f808fd1f04ec62cbcd0c40cffe0b3b605b4
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
