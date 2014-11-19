# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-sed
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.1-2
$(PKG)_CHECKSUM := 0d6341111cf2b627105f3c735015ffa2bd7a71d1
$(PKG)_REMOTE_SUBDIR := sed/sed-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := sed-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/sed' | \
    $(SED) -n 's,.*title="sed-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
