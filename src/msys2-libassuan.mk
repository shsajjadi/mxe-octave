# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libassuan
$(PKG)_NAME     := libassuan
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.1-1
$(PKG)_x86_64_CS := 0d38ff6961a743c933d28c88daa9a0f05ed8327b
$(PKG)_i686_CS  := c5b956eab94dae8a5ff7eb3ad78eda9ee911a9bd
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
