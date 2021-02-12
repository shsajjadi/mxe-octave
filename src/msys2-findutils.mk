# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-findutils
$(PKG)_NAME     := findutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.7.0-1
$(PKG)_x86_64_CS := dacf83fddf197b74be16d55cbab41866cd1dd66f
$(PKG)_i686_CS  := 0e995f9cdd4c563695ab028cb25bbccbbda19596
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
