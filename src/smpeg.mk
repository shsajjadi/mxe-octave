# This file is part of MXE.
# See index.html for further information.

PKG             := smpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.5+cvs20030824
$(PKG)_CHECKSUM := d3460181f4b5e79b33f3bf4e9642a4fe6f98bc89
$(PKG)_SUBDIR   := smpeg-$($(PKG)_VERSION).orig
$(PKG)_FILE     := smpeg_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_URL      := http://ftp.debian.org/debian/pool/main/s/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://packages.debian.org/unstable/source/smpeg' | \
    $(SED) -n 's,.*smpeg_\([0-9][^>]*\)\.orig\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,\(-lsmpeg\),\1 -lstdc++,' '$(1)/smpeg-config.in'
    cd '$(1)' && ./configure \
        AR='$(MXE_AR)' \
        NM='$(MXE_NM)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-debug \
        --prefix='$(HOST_PREFIX)' \
        --with-sdl-prefix='$(HOST_PREFIX)' \
        --disable-sdltest \
        --disable-gtk-player \
        --disable-opengl-player \
        CFLAGS='-ffriend-injection'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(MXE_CC)' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-smpeg.exe' \
        `'$(HOST_BINDIR)/smpeg-config' --cflags --libs`
endef
