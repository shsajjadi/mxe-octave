# This file is part of MXE.
# See index.html for further information.

PKG             := librsvg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.36.4
$(PKG)_CHECKSUM := 1e0152e6745bac9632207252c67dda2299010db4
$(PKG)_SUBDIR   := librsvg-$($(PKG)_VERSION)
$(PKG)_FILE     := librsvg-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/librsvg/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := glib libgsf cairo pango gtk2 libcroco

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/GNOME/librsvg/tags' | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-pixbuf-loader \
        --disable-gtk-theme \
        --disable-gtk-doc \
        --enable-introspection=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-librsvg.exe' \
        `'$(MXE_PKG_CONFIG)' librsvg-2.0 --cflags --libs`
endef
