# This file is part of MXE.
# See index.html for further information.

PKG             := of-dicom
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.1
$(PKG)_CHECKSUM := dfb7eccf6ccc39e52c27a5d885984eaa3a55d3d4
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := dicom
$(PKG)_FILE     := dicom-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     := gdcm cmake

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="dicom-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(OCTAVE_FORGE_PKG_BUILD)
endef
