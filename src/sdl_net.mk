# This file is part of MXE.
# See doc/index.html for further information.

# SDL_net
PKG             := sdl_net
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.8
$(PKG)_CHECKSUM := fd393059fef8d9925dc20662baa3b25e02b8405d
$(PKG)_SUBDIR   := SDL_net-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_net-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.libsdl.org/projects/SDL_net/
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_net/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl

define $(PKG)_UPDATE
    wget -q -O- 'http://www.libsdl.org/cgi/viewvc.cgi/tags/SDL_net/?sortby=date' | \
    grep '<a name="' | \
    $(SED) -n 's,.*<a name="release-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-gui
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_net.exe' \
        `'$(TARGET)-pkg-config' SDL_net --cflags --libs`
endef
