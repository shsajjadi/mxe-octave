# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# ATK
PKG             := atk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.30.0
$(PKG)_CHECKSUM := ca9380e956e37275cb0cb72805d20306686fb885
$(PKG)_SUBDIR   := atk-$($(PKG)_VERSION)
$(PKG)_FILE     := atk-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtk.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/atk/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib gettext

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/atk/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=ATK_\\([0-9][^']*\\)'.*,\\1,p" | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,DllMain,static _disabled_DllMain,' '$(1)/atk/atkobject.c'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-glibtest \
        --disable-gtk-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
