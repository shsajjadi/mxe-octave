# This file is part of MXE.
# See index.html for further information.

PKG             := of-odepkg
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 74b7e88ad5a104e064c413f077a5e5327741efb4
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := odepkg
$(PKG)_FILE     := odepkg-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
