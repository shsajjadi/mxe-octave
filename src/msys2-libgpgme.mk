# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libgpgme
$(PKG)_NAME     := libgpgme
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.13.0-1
$(PKG)_x86_64_CS := 90899a4f20802b2461555d4b722d4ba6d5a730cc
$(PKG)_i686_CS  := fb850eeb3691abba71aca0a3a1bb66633982a8e6
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
