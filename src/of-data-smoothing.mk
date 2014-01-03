# This file is part of MXE.
# See index.html for further information.

PKG             := of-data-smoothing
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 28fb1233f0db586bccac9317f0f0eff84bb9842e
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := data-smoothing
$(PKG)_FILE     := data-smoothing-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     := of-optim

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
