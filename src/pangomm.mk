# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Pangomm
PKG             := pangomm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.26.2
$(PKG)_CHECKSUM := 67ebf73e36dc829ab3e7ff76c0e447dc0a031f14
$(PKG)_SUBDIR   := pangomm-$($(PKG)_VERSION)
$(PKG)_FILE     := pangomm-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.pango.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/pangomm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cairomm glibmm pango

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/pangomm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
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
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
