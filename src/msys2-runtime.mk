# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-runtime
$(PKG)_NAME     := msys2-runtime
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.0-2
$(PKG)_x86_64_CS := 3114f4827aa9d3d0a90f9d958c4d657a2f944972
$(PKG)_i686_CS  := 146e6c76dcfddedc2fe1f9926dd7061e64544fd6
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
