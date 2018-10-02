# This file is part of MXE.
# See index.html for further information.

PKG             := gtk2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.24.10
$(PKG)_CHECKSUM := baf5c73e186352cad767392a6b55840be0326ddc
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext libpng jpeg tiff jasper glib atk pango cairo gdk-pixbuf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/GNOME/gtk/tags?after=3.23.0' | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | \
    grep -v '^2\.9' | \
    grep '^2\.' | \
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
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-gtk2.exe' \
        `'$(MXE_PKG_CONFIG)' gtk+-2.0 --cflags --libs`
endef
