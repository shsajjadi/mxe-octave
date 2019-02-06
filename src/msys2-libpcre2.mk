# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libpcre2
$(PKG)_NAME     := libpcre2_8
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 10.32-1
$(PKG)_x86_64_CS := 37ad08587df7816ce06a8f87ea603876c6e57c7a
$(PKG)_i686_CS  := f638c43e758093f8385472d63008d78456b1da12
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
