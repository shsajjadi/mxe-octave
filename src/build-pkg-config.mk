# This file is part of MXE.
# See index.html for further information.

PKG             := build-pkg-config
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 71853779b12f958777bffcb8ca6d849b4d3bed46
$(PKG)_SUBDIR   := pkg-config-$($(PKG)_VERSION)
$(PKG)_FILE     := pkg-config-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://pkgconfig.freedesktop.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --with-internal-glib \
        --with-pc-path='$(MXE_LIBDIR)/pkgconfig' \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    rm -f "$(BUILD_TOOLS_PREFIX)/bin/`config.guess`-pkg-config"
    $(MAKE) -C '$(1).build' -j 1 install
endef
