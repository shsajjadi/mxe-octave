# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-coreutils
$(PKG)_NAME     := coreutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.32-1
$(PKG)_x86_64_CS := 36b081092621b430b19f5280e5f5116875730cbb
$(PKG)_i686_CS  := 382b60317c7dcbd9d341de8df2025f1370c25c99
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
