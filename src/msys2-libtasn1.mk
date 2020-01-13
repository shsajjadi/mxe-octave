# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libtasn1
$(PKG)_NAME     := libtasn1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.15.0-1
$(PKG)_x86_64_CS := 725d15b29814a2ce5caf744291d032e66b2e9127
$(PKG)_i686_CS  := 9e65e70ca62aed5b4988a14cf06ce2869bf8721a
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
