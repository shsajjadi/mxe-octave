# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libpcre
$(PKG)_NAME     := libpcre
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.42-1
$(PKG)_x86_64_CS := 87482668ef721bf33c1ab34bba8d31af13fcc2f4
$(PKG)_i686_CS  := d64e4a86813dbcc22c2dba7e3e0b9dbc4dd53082
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
