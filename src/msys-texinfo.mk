# This file is part of MXE.
# See index.html for further information.

PKG             := msys-texinfo
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 
$(PKG)_REMOTE_SUBDIR := texinfo/texinfo-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := texinfo-$($(PKG)_VERSION)-msys-1.0.13-bin.tar.lzma
$(PKG)_URL      := $(MSYS_BASE_URL)/$($(PKG)_REMOTE_SUBDIR)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(MSYS_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(MSYS_BASE_DIR)'; tar xpf - )
    mkdir -p '$(PREFIX)'/../msys-info
    cd '$(1)' && find . > '$(PREFIX)'/../msys-info/$(PKG).list
endef
