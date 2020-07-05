# This file is part of MXE.
# See index.html for further information.

PKG             := build-setuptools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 44.1.1
$(PKG)_CHECKSUM := d1ba6f62520e09956bc3163291a26b185fdff2c6
$(PKG)_SUBDIR   := setuptools-$($(PKG)_VERSION)
$(PKG)_FILE     := setuptools-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://files.pythonhosted.org/packages/b2/40/4e00501c204b457f10fe410da0c97537214b2265247bc9a5bc6edd55b9e4/$($(PKG)_FILE)
$(PKG)_DEPS     := build-python

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && python2 setup.py install --prefix='$(BUILD_TOOLS_PREFIX)'
endef
