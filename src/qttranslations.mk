# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qttranslations
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := ab726c8311749191a7fcdef5aa317ee72779e983
$(PKG)_SUBDIR    = $(subst qtbase,qttranslations,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qttranslations,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qttranslations,$(qtbase_URL))
$(PKG)_DEPS     := qtbase qttools

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(MXE_QMAKE)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

