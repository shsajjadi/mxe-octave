# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libffi
$(PKG)_NAME     := libffi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3-1
$(PKG)_x86_64_CS := 14e19984f304de251e137f27e66900b546812d90
$(PKG)_i686_CS  := 4904e013c6180ea0c13298082cff9edd39697a61
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
