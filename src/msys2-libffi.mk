# This file is part of MXE.
# See index.html for further information.

PKG             := msys2-libffi
$(PKG)_NAME     := libffi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.1-3
$(PKG)_x86_64_CS := 6c874a3d2d67adb68a2e9798f038b555f838dc17
$(PKG)_i686_CS  := fe7592754aa2949e36716868c5ca66f6e413592a
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
