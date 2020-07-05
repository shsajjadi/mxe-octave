# This file is part of MXE.
# See index.html for further information.

PKG             := build-markupsafe
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0
$(PKG)_CHECKSUM := 9072e80a7faa0f49805737a48f3d871eb1c48728
$(PKG)_SUBDIR   := MarkupSafe-$($(PKG)_VERSION)
$(PKG)_FILE     := MarkupSafe-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://pypi.python.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/$($(PKG)_FILE)
$(PKG)_DEPS     := build-python3 build-setuptools

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && $(PYTHON3) setup.py install --prefix='$(BUILD_TOOLS_PREFIX)'
endef

