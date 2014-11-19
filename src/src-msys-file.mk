# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-file
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.04-1
$(PKG)_CHECKSUM := e30df31c333cdba1137dc236e005a64a604bde8e
$(PKG)_REMOTE_SUBDIR := file/file-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := file-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/file' | \
    $(SED) -n 's,.*title="file-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
