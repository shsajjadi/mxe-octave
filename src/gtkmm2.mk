# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GTKMM
PKG             := gtkmm2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.24.0
$(PKG)_CHECKSUM := 9b9e68360fb3f5faa7f221acba56f0d75a8198d2
$(PKG)_SUBDIR   := gtkmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkmm-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtkmm.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtkmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtk2 libsigc++ pangomm cairomm atkmm

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/gtkmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep -v '^2\.9' | \
    grep '^2\.' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic -std=c++0x \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-gtkmm2.exe' \
        `'$(TARGET)-pkg-config' gtkmm-2.4 --cflags --libs`
endef
