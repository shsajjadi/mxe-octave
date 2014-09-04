# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-findutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.4.2-2
$(PKG)_CHECKSUM := 7f0552c56197e8c306845cc9e4334d3dd7a719da
$(PKG)_REMOTE_SUBDIR := findutils/findutils-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := findutils-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/findutils' | \
    $(SED) -n 's,.*title="findutils-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
