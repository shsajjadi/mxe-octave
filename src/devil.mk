# This file is part of MXE.
# See index.html for further information.

PKG             := devil
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.8
$(PKG)_CHECKSUM := bc27e3e830ba666a3af03548789700d10561fcb1
$(PKG)_SUBDIR   := devil-$($(PKG)_VERSION)
$(PKG)_FILE     := DevIL-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/openil/DevIL/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := freeglut zlib openexr jpeg jasper lcms libmng libpng tiff sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/p/openil/svn/HEAD/tree/tags/' | \
    grep 'href="' | \
    $(SED) -n 's,.*href="release-\([0-9][^"]*\)".*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/include/IL/il.h'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-ILU \
        --enable-ILUT \
        --disable-allegro \
        --disable-directx8 \
        --enable-directx9 \
        --enable-opengl \
        --enable-sdl \
        --disable-sdltest \
        --disable-wdp \
        --with-zlib \
        --without-squish \
        --without-nvtt \
        --without-x \
        --without-examples
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= INFO_DEPS=
endef
