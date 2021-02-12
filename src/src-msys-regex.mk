# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-regex
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.20090805-2
$(PKG)_CHECKSUM := 538cf83a0971d7e9f5679de2ad6af8da2d9b95a8
$(PKG)_REMOTE_SUBDIR := regex/regex-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := regex-$($(PKG)_VERSION)-msys-1.0.13-src.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/regex' | \
    $(SED) -n 's,.*title="regex-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
