# This file is part of MXE.
# See index.html for further information.

PKG             := of-dicom
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := dfb7eccf6ccc39e52c27a5d885984eaa3a55d3d4
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := dicom
$(PKG)_FILE     := dicom-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     := gdcm

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
