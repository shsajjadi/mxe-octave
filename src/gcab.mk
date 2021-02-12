# This file is part of MXE.
# See index.html for further information.

PKG             := gcab
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4
$(PKG)_CHECKSUM := d81dfe35125e611e3a94c0d4def37ebf62b9187c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := glib zlib intltool

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' '$(1)/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build' -j 1 install
endef
