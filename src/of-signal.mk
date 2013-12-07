# This file is part of MXE.
# See index.html for further information.

PKG             := of-signal
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 87ed51b878ac49d32c328032500dff452132240b
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := signal
$(PKG)_FILE     := signal-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := of-specfun of-control of-general

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
