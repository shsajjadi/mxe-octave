# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Pango
PKG             := pango
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.28.2
$(PKG)_CHECKSUM := 326e9afa015ac5328fb1f9ecc2212e327396008c
$(PKG)_SUBDIR   := pango-$($(PKG)_VERSION)
$(PKG)_FILE     := pango-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.pango.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/pango/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc fontconfig freetype cairo glib

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/pango/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gtk-doc \
        --without-x \
        --enable-explicit-deps \
        --with-included-modules \
        --without-dynamic-modules \
        CXX='$(TARGET)-g++' \
        LIBS='-lusp10'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
