# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-dos2unix
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.3.2-1
$(PKG)_CHECKSUM := 66f6e21dba7e9cf3ebe2c93772d75bfe1eff13a0
$(PKG)_REMOTE_SUBDIR := dos2unix/dos2unix-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := dos2unix-$($(PKG)_VERSION)-msys-1.0.18-src.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/dos2unix' | \
    $(SED) -n 's,.*title="dos2unix-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
