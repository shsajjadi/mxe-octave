# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-gnupg
$(PKG)_NAME     := gnupg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.15-2
$(PKG)_x86_64_CS := 524c181d0e897d475976e1bd5fb01775336948ff
$(PKG)_i686_CS  := ccbf6a61c16f232591f77652c9eaf054c1733d8c
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
