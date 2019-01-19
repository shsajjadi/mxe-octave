# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-keyring
$(PKG)_NAME     := msys2-keyring
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := r9.397a52e-1
# the keyring package is the same for both systems
$(PKG)_x86_64_CS := 846109181a3d49def1da5a422be5d80c4ecb14df
$(PKG)_CS       := $($(PKG)_x86_64_CS)
$(PKG)_CHECKSUM := $($(PKG)_CS)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION)-any.pkg.tar.xz
$(PKG)_URL      := $(MSYS2_URL)/$($(PKG)_FILE)/download

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(MSYS2_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(MSYS2_PKG_BUILD)
endef
