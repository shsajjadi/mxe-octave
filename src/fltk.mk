# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# FLTK
PKG             := fltk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.x-r8617
$(PKG)_CHECKSUM := 9539b7671a7a3bfdd2a7f1ef23b670ead91d8f2d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_WEBSITE  := http://www.fltk.org/
$(PKG)_URL      := http://ftp.easysw.com/pub/fltk/snapshots/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg libpng pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://www.fltk.org/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    grep -v '^1\.1\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    $(SED) -i 's,\$$uname,MINGW,g' '$(1)/configure'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads \
        LIBS='-lws2_32'
    # enable exceptions, because disabling them doesn't make any sense on PCs
    $(SED) -i 's,-fno-exceptions,,' '$(1)/makeinclude'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DIRS=src LIBCOMMAND='$(TARGET)-ar cr'
endef
