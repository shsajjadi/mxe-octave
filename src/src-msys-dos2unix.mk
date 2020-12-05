# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-dos2unix
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.4.0-1
$(PKG)_CHECKSUM := d30eec43661495eaa05456259404832277fe3e06
$(PKG)_REMOTE_SUBDIR := dos2unix/dos2unix-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := dos2unix-$($(PKG)_VERSION)-msys-1.0.19-src.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/dos2unix' | \
    $(SED) -n 's,.*title="dos2unix-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
