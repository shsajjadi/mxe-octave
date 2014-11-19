# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-less
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 436-2
$(PKG)_CHECKSUM := 31dd72593f3a3298b54e80b006b4e2b883d3b592
$(PKG)_REMOTE_SUBDIR := less/less-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := less-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/less' | \
    $(SED) -n 's,.*title="less-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
