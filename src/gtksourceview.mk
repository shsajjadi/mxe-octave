# This file is part of MXE.
# See index.html for further information.

PKG             := gtksourceview
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.5
$(PKG)_CHECKSUM := 5081dc7a081954d0af73852c22e874a746bda30e
$(PKG)_SUBDIR   := gtksourceview-$($(PKG)_VERSION)
$(PKG)_FILE     := gtksourceview-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtksourceview/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gtk2 libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- https://github.com/GNOME/gtksourceview/tags | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | grep -v '^2\.9[0-9]\.' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-gtk-doc \
        GLIB_GENMARSHAL='$(HOST_BINDIR)/glib-genmarshal' \
        GLIB_MKENUMS='$(HOST_BINDIR)/glib-mkenums'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
