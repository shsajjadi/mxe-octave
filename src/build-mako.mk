# This file is part of MXE.
# See index.html for further information.

PKG             := build-mako
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.7
$(PKG)_CHECKSUM := bf0c1f4cdfca4dd37bc0c9f83e984a0558268b42
$(PKG)_SUBDIR   := Mako-$($(PKG)_VERSION)
$(PKG)_FILE     := Mako-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://pypi.python.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/$($(PKG)_FILE)
$(PKG)_DEPS     := build-python build-markupsafe build-setuptools

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && python2 setup.py install --prefix='$(BUILD_TOOLS_PREFIX)'
endef
