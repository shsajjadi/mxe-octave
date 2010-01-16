# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# cairo
PKG             := cairo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.8
$(PKG)_CHECKSUM := e4b8b219427d1ca3dc95f5f44914dce1ae0c3766
$(PKG)_SUBDIR   := cairo-$($(PKG)_VERSION)
$(PKG)_FILE     := cairo-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://cairographics.org/
$(PKG)_URL      := http://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib libpng fontconfig freetype pixman

define $(PKG)_UPDATE
    wget -q -O- 'http://cairographics.org/releases/' | \
    grep 'LATEST-cairo-' | \
    $(SED) -n 's,.*"LATEST-cairo-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,libpng12,libpng,g'                          -i '$(1)/configure'
    $(SED) 's,^\(Libs:.*\),\1 @CAIRO_NONPKGCONFIG_LIBS@,' -i '$(1)/src/cairo.pc.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gtk-doc \
        --disable-test-surfaces \
        --disable-gcov \
        --disable-xlib \
        --disable-xlib-xrender \
        --disable-xcb \
        --disable-quartz \
        --disable-quartz-font \
        --disable-quartz-image \
        --disable-os2 \
        --disable-beos \
        --disable-glitz \
        --disable-directfb \
        --enable-win32 \
        --enable-win32-font \
        --enable-png \
        --enable-ft \
        --enable-ps \
        --enable-pdf \
        --enable-svg \
        --disable-pthread \
        LIBS="-lmsimg32 -lgdi32 `$(TARGET)-pkg-config pixman-1 --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
