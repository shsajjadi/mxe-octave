# This file is part of MXE.
# See index.html for further information.

PKG             := msys-termcap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.20050421_1-2
$(PKG)_CHECKSUM := e4273ccfde8ecf3a7631446fb2b01971a24ff9f7
$(PKG)_REMOTE_SUBDIR := termcap/termcap-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := libtermcap-$($(PKG)_VERSION)-msys-1.0.13-dll-0.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(MSYS_BASE_URL)/termcap' | \
    $(SED) -n 's,.*title="termcap-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(MSYS_INFO_DIR)'
    cd '$(1)' && find . > '$(MSYS_INFO_DIR)'/$(PKG).list
endef
