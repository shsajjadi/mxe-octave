# This file is part of MXE.
# See index.html for further information.

PKG             := of-communications
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 8c358c02ddd84047db62d5f36125630ea940e41b
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := communications
$(PKG)_FILE     := communications-$($(PKG)_VERSION).tar.gz
$(PKG)_FIXED_FILE := communications-$($(PKG)_VERSION)a.tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(HOST_PREFIX)/src'
    cd '$(1)/..' \
      && tar czf $($(PKG)_FIXED_FILE) $($(PKG)_SUBDIR) \
      && $(INSTALL) -m644 '$($(PKG)_FIXED_FILE)' '$(HOST_PREFIX)/src'
endef
