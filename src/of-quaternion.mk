# This file is part of MXE.
# See index.html for further information.

PKG             := of-quaternion
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a0812bb1891913dc51e1285f18c4350f662799cf
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := quaternion
$(PKG)_FILE     := quaternion-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
