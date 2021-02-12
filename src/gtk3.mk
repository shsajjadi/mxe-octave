# This file is part of MXE.
# See index.html for further information.

PKG             := gtk3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.2
$(PKG)_CHECKSUM := c519b553b618588f288c70ea5dce1145588944eb
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext libpng jpeg tiff jasper glib atk pango cairo gdk-pixbuf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/GNOME/gtk/tags' | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | \
    grep -v '^3\.9' | \
    grep '^3\.' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-explicit-deps \
        --disable-glibtest \
        --disable-modules \
        --disable-cups \
        --disable-test-print-backend \
        --disable-gtk-doc \
        --disable-man \
        --with-included-immodules \
        --without-x \
	PKG_CONFIG='$(MXE_PKG_CONFIG)' \
	PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install noinst_PROGRAMS=
endef
