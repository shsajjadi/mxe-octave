# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-grep
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.4-2
$(PKG)_CHECKSUM := e950afc36c2450253785dd5d69f0bf8e5f2ee015
$(PKG)_REMOTE_SUBDIR := grep/grep-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := grep-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/grep' | \
    $(SED) -n 's,.*title="grep-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
