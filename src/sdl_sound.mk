# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_sound
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.3
$(PKG)_CHECKSUM := 1984bc20b2c756dc71107a5a0a8cebfe07e58cb1
$(PKG)_SUBDIR   := SDL_sound-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_sound-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://icculus.org/SDL_sound/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := sdl libmikmod ogg vorbis flac speex

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.icculus.org/icculus/SDL_sound/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-sdl-prefix='$(HOST_PREFIX)' \
        --disable-sdltest \
        --enable-voc \
        --enable-wav \
        --enable-raw \
        --enable-aiff \
        --enable-au \
        --enable-shn \
        --enable-midi \
        --disable-smpeg \
        --enable-mpglib \
        --enable-mikmod \
        --disable-modplug \
        --enable-ogg \
        --enable-flac \
        --enable-speex \
        --disable-physfs \
        --disable-altcvt \
        CFLAGS='-g -O2 -fno-inline' \
        LIBS="`'$(MXE_PKG_CONFIG)' vorbisfile flac speex --libs` `'$(HOST_BINDIR)/libmikmod-config' --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(MXE_CC)' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-sdl_sound.exe' \
        -lSDL_sound \
        `'$(MXE_PKG_CONFIG)' sdl vorbisfile flac speex --cflags --libs` \
        `'$(HOST_BINDIR)/libmikmod-config' --cflags --libs`
endef
