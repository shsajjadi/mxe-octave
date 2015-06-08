# This file is part of MXE.
# See index.html for further information.

PKG             := src-msys-perl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.8.8-1
$(PKG)_CHECKSUM := 2510a7ff6bf9486d0ffe51f86f8b4a57366c809c
$(PKG)_REMOTE_SUBDIR := perl/perl-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := perl-$($(PKG)_VERSION)-msys-1.0.17-src.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/perl' | \
    $(SED) -n 's,.*title="perl-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
endef
