# This file is part of MXE.
# See index.html for further information.

PKG             := of-optim
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c1fbd588dd11150ff4e973d4b93582c8bd6126ed
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := optim-$($(PKG)_VERSION)
$(PKG)_FILE     := optim-$($(PKG)_VERSION).tar.gz
$(PKG)_FIXED_FILE := optim-$($(PKG)_VERSION)a.tar.gz
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
