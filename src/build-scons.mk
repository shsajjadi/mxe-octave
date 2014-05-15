# This file is part of MXE.
# See index.html for further information.

PKG             := build-scons
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := 775e715e49fe5fd8e1d29551a296fdc9267509e7
$(PKG)_SUBDIR   := scons-$($(PKG)_VERSION)
$(PKG)_FILE     := scons-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://prdownloads.sourceforge.net/scons/$($(PKG)_FILE)
$(PKG)_DEPS     := build-python

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && python setup.py install
endef
