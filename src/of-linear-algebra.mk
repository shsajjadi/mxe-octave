# This file is part of MXE.
# See index.html for further information.

PKG             := of-linear-algebra
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 513d69169248c903e57cbf8b6a82e850e377045b
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := linear-algebra
$(PKG)_FILE     := linear-algebra-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
