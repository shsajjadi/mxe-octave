# This file is part of MXE.
# See index.html for further information.

PKG             := of-image
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 30f33db706e8892f120f2d79e030c3f21dea4563
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := image
$(PKG)_FILE     := image-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := of-signal

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
