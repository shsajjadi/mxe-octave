# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-gawk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.7-2
$(PKG)_CHECKSUM := c2b81658b06c2c4d0e40f34a54b6a7818da6325c
$(PKG)_REMOTE_SUBDIR := gawk/gawk-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := gawk-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/gawk' | \
    $(SED) -n 's,.*title="gawk-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
