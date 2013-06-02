# This file is part of MXE.
# See index.html for further information.

PKG             := build-libtool
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 22b71a8b5ce3ad86e1094e7285981cae10e6ff88
$(PKG)_SUBDIR   := libtool-$($(PKG)_VERSION)
$(PKG)_FILE     := libtool-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/libtool/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
