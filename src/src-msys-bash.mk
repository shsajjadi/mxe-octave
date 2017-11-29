# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-bash
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.23-1
$(PKG)_CHECKSUM := be0978971617fdf9832a40415fd243bc26a228ff
$(PKG)_REMOTE_SUBDIR := bash/bash-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := bash-$($(PKG)_VERSION)-msys-1.0.18-src.tar.xz
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 
define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/bash' | \
    $(SED) -n 's,.*title="bash-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
