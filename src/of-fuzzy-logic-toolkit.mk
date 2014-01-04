# This file is part of MXE.
# See index.html for further information.

PKG             := of-fuzzy-logic-toolkit
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 75f9d948ea599c4d214950d3f4d12248ce212827
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := fuzzy-logic-toolkit
$(PKG)_FILE     := fuzzy-logic-toolkit-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
