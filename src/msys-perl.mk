# This file is part of MXE.
# See index.html for further information.

PKG             := msys-perl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.8.8-1
$(PKG)_CHECKSUM := 5123c6499393ae952d1c38abd49118d192ae0aa0
$(PKG)_REMOTE_SUBDIR := perl/perl-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := perl-$($(PKG)_VERSION)-msys-1.0.17-bin.tar.lzma
$(PKG)_URL      := $(MSYS_EXTENSION_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_EXTENSION_URL)/perl' | \
    $(SED) -n 's,.*title="perl-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_EXTENSION_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_EXTENSION_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
