# This file is part of MXE.
# See index.html for further information.

PKG             := build-autoconf
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e891c3193029775e83e0534ac0ee0c4c711f6d23
$(PKG)_SUBDIR   := autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := autoconf-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/autoconf/$($(PKG)_FILE)
$(PKG)_DEPS     := build-xz

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
