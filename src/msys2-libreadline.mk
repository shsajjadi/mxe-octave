# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libreadline
$(PKG)_NAME     := libreadline
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.0.000-1
$(PKG)_x86_64_CS := 398cd22583c8669ac67c493b7d8c558500bb115e
$(PKG)_i686_CS  := 3a0ecbf06498d6e7a9eb35339b8ee730b77756b2
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
