# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-patch
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.1-1
$(PKG)_CHECKSUM := bdf8933845b2e2d5aad5fc05bf2665845a8091a3
$(PKG)_REMOTE_SUBDIR := patch/patch-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := patch-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/patch' | \
    $(SED) -n 's,.*title="patch-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
