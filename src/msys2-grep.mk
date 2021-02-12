# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-grep
$(PKG)_NAME     := grep
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1-1
$(PKG)_x86_64_CS := 829a127bad77745fb2f742b97e5df33befd5c19f
$(PKG)_i686_CS  := 5f77829c93755967ea5e978e56ca137155e032c6
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
