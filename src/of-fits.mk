# This file is part of MXE.
# See index.html for further information.

PKG             := of-fits
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 6aecd4611879acaae1918025148cc09e197e0e82
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := fits
$(PKG)_FILE     := fits-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     := pkg-config cfitsio

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
