# This file is part of MXE.
# See index.html for further information.

PKG             := sdl
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 0c5f193ced810b0d7ce3ab06d808cbb5eef03a2c
$(PKG)_SUBDIR   := SDL-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,-mwindows,-lwinmm -mwindows,' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads \
        --enable-directx \
        --disable-stdio-redirect
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(LN_SF) '$(HOST_BINDIR)/sdl-config' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)sdl-config'

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-sdl.exe' \
        `'$(MXE_PKG_CONFIG)' sdl --cflags --libs`
endef
