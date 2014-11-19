# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-coreutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.97-3
$(PKG)_CHECKSUM := b77b025d6bbbfac040ddba8cc56591bedb8abb63
$(PKG)_REMOTE_SUBDIR := coreutils/coreutils-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := coreutils-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/coreutils' | \
    $(SED) -n 's,.*title="coreutils-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
