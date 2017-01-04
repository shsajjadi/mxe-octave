# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-msys-core
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.19-1
$(PKG)_CHECKSUM := 8fe75384cecbbac86b030eb90eea0e01556cb460
$(PKG)_REMOTE_SUBDIR := msys-core/msys-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := msysCORE-$($(PKG)_VERSION)-msys-1.0.19-src.tar.xz
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/msys-core' | \
    $(SED) -n 's,.*title="msys-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
