# This file is part of MXE.
# See index.html for further information.

PKG             := gdk-pixbuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.28.2
$(PKG)_CHECKSUM := 9876d0a20f592f8fb2a52d4a86ec43d607661beb
$(PKG)_SUBDIR   := gdk-pixbuf-$($(PKG)_VERSION)
$(PKG)_FILE     := gdk-pixbuf-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := glib libpng jasper libiconv
ifneq ($(MXE_SYSTEM),msvc)
    $(PKG)_DEPS += jpeg tiff
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/GNOME/gdk-pixbuf/tags' | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

$(PKG)_EXTRA_CONFIGURE_OPTIONS :=
ifneq ($(MXE_SYSTEM),msvc)
    $(PKG)_EXTRA_CONFIGURE_OPTIONS += --without-gdiplus
endif

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -I '$(HOST_PREFIX)/share/aclocal' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-modules \
        --with-included-loaders \
        --with-libjasper \
        $($(PKG)_EXTRA_CONFIGURE_OPTIONS) \
	PKG_CONFIG='$(MXE_PKG_CONFIG)' \
	PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
