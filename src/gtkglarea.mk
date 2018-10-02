# This file is part of MXE.
# See index.html for further information.

PKG             := gtkglarea
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.1
$(PKG)_CHECKSUM := db12f2bb9a3d28d69834832e2e04a255acfd8a6d
$(PKG)_SUBDIR   := gtkglarea-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglarea-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnome.org/pub/gnome/sources/gtkglarea/2.0/$($(PKG)_FILE)
$(PKG)_DEPS     := gtk2 freeglut

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnome.org/pub/gnome/sources/gtkglarea/2.0/' | \
    $(SED) -n 's,.*gtkglarea-\(2[^>]*\)\.tar.*,\1,ip' | \
    sort | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi # to be removed if patch is integrated upstream
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
