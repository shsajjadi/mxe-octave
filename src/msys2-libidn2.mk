# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libidn2
$(PKG)_NAME     := libidn2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.0-1
$(PKG)_x86_64_CS := 811b26b1500d07e2a17526c7a0e510a4fca671bb
$(PKG)_i686_CS  := 32452e5f218b8fbb62d01f1b7142cbb7244acf91
$(PKG)_CS       := $($(PKG)_$(MSYS2_ARCH)_CS)
$(PKG)_CHECKSUM := $($(PKG)_CS)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION)-$(MSYS2_ARCH).pkg.tar.xz
$(PKG)_URL      := $(MSYS2_URL)/$($(PKG)_FILE)/download

#https://sourceforge.net/projects/msys2/files/REPOS/MSYS2/x86_64/bash-4.4.019-3-x86_64.pkg.tar.xz/download

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(MSYS2_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(MSYS2_PKG_BUILD)
endef
