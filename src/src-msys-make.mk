# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-make
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.81-3
$(PKG)_CHECKSUM := 6c5453bf2b47257573cc6be782986a83f219b78b
$(PKG)_REMOTE_SUBDIR := make/make-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := make-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/make' | \
    $(SED) -n 's,.*title="make-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
