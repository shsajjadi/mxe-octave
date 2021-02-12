# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-unzip
$(PKG)_NAME     := unzip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.0-2
$(PKG)_x86_64_CS := 703b6727f8c516a9a37eb0ef73cb2f097ca45979
$(PKG)_i686_CS  := f985cc6b17eff01c79390cdc9a2f88074d7d0899
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
