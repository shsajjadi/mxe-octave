# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-gawk
$(PKG)_NAME     := gawk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.1-1
$(PKG)_x86_64_CS := 229c0d55cdb229dfc875a8ce016ecb5a5c79ba6f
$(PKG)_i686_CS  := 0baab3a09e43d2900d35bb96f1dc1743a81de644
$(PKG)_CS       := $($(PKG)_$(MSYS2_ARCH)_CS)
$(PKG)_CHECKSUM := $($(PKG)_CS)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $($(PKG)_NAME)-$($(PKG)_VERSION)-$(MSYS2_ARCH).pkg.tar.xz
$(PKG)_URL      := $(MSYS2_URL)/$($(PKG)_FILE)/download

$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS2_BASE_URL)/' | \
    $(SED) -n 's,.*title="$($(PKG)_NAME)-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(MSYS2_PKG_BUILD)
endef
