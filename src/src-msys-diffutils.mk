# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-diffutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.7.20071206cvs-3
$(PKG)_CHECKSUM := 8fd96ee0639533a06aff49764234d50360624c3f
$(PKG)_REMOTE_SUBDIR := diffutils/diffutils-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := diffutils-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/diffutils' | \
    $(SED) -n 's,.*title="diffutils-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
