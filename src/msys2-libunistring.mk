# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libunistring
$(PKG)_NAME     := libunistring
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.10-1
$(PKG)_x86_64_CS := 9e0f52dbef4127cd94e6d4ba978b8177f3c1e291
$(PKG)_i686_CS  := a291d33ba496555f17f1da651228ba9448c1f96b
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
