# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GEOS
PKG             := geos
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.0
$(PKG)_CHECKSUM := f6c6e3398d5c7bf389a0610a0d06896d76ad4480
$(PKG)_SUBDIR   := geos-$($(PKG)_VERSION)
$(PKG)_FILE     := geos-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://trac.osgeo.org/geos/
$(PKG)_URL      := http://download.osgeo.org/geos/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/geos/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://geos.refractions.net/' | \
    $(SED) -n 's,.*geos-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-swig
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-geos.exe' \
        -lgeos_c `'$(PREFIX)/$(TARGET)/bin/geos-config' --cflags --libs` -lstdc++
endef
