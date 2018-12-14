# This file is part of MXE.
# See index.html for further information.

PKG             := qtimageformats
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 078f96837498528ba2a70c946e608786e902461c
$(PKG)_SUBDIR    = $(subst qtbase,qtimageformats,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtimageformats,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtimageformats,$(qtbase_URL))
$(PKG)_DEPS     := jasper libmng qtbase tiff

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(MXE_QMAKE)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
