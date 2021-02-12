# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_net
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.8
$(PKG)_CHECKSUM := fd393059fef8d9925dc20662baa3b25e02b8405d
$(PKG)_SUBDIR   := SDL_net-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_net-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_net/release/$($(PKG)_FILE)
$(PKG)_DEPS     := sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL_net/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    $(GREP) "^1" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-sdl-prefix='$(HOST_PREFIX)' \
        --disable-sdltest \
        --disable-gui
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-sdl_net.exe' \
        `'$(MXE_PKG_CONFIG)' SDL_net --cflags --libs`
endef
