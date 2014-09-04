# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-termcap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.20050421_1-2
$(PKG)_CHECKSUM := f5e22018742966dd57f6c5dbb73c2672ce07994b
$(PKG)_REMOTE_SUBDIR := termcap/termcap-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := termcap-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/termcap' | \
    $(SED) -n 's,.*title="termcap-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
