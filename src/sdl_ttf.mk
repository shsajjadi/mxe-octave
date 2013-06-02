# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_ttf
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 0ccf7c70e26b7801d83f4847766e09f09db15cc6
$(PKG)_SUBDIR   := SDL_ttf-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_ttf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_ttf/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl freetype

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL_ttf/tags' | \
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
        --with-freetype-prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
