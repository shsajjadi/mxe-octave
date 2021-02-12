# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libmetalink
$(PKG)_NAME     := libmetalink
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.3-2
$(PKG)_x86_64_CS := f7abd405c888b5c5cd2a668cfb147cb771b35873
$(PKG)_i686_CS  := e52a76c44404fd8242cdb397e3b2dd46f9a818ce
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
