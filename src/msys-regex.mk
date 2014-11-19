# This file is part of MXE.
# See index.html for further information.

PKG             := msys-regex
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.20090805-2
$(PKG)_CHECKSUM := d95faa144cf06625b3932a8e84ed1a6ab6bbe644
$(PKG)_REMOTE_SUBDIR := regex/regex-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := libregex-$($(PKG)_VERSION)-msys-1.0.13-dll-1.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/regex' | \
    $(SED) -n 's,.*title="regex-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
