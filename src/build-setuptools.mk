# This file is part of MXE.
# See index.html for further information.

PKG             := build-setuptools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 36.5.0
$(PKG)_CHECKSUM := 4edca327d0666d6956d05cef8fd6dfcce6e701db
$(PKG)_SUBDIR   := setuptools-$($(PKG)_VERSION)
$(PKG)_FILE     := setuptools-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://pypi.python.org/packages/a4/c8/9a7a47f683d54d83f648d37c3e180317f80dc126a304c45dc6663246233a/$($(PKG)_FILE)
$(PKG)_DEPS     := build-python

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && python setup.py install
endef
