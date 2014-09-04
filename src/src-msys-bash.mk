# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-bash
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.17-4
$(PKG)_CHECKSUM := 
$(PKG)_REMOTE_SUBDIR := bash/bash-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := bash-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/bash' | \
    $(SED) -n 's,.*title="bash-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
