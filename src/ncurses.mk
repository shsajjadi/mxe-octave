# This file is part of MXE.
# See index.html for further information.

# ncurses
PKG             := ncurses
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3e042e5f2c7223bffdaac9646a533b8c758b65b5
$(PKG)_SUBDIR   := ncurses-$($(PKG)_VERSION)
$(PKG)_FILE     := ncurses-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/ncurses/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/pub/gnu/ncurses/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="ncurses-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

# Building with --enable-shared doesn't seem to work for MinGW systems
# with this version of ncurses, so fake it.

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix=$(PREFIX)/$(TARGET) \
        --disable-home-terminfo \
        --enable-sp-funcs \
        --enable-term-driver \
        --enable-interop \
        --without-debug \
        --without-ada \
        --without-manpages \
        --enable-pc-files \
        --with-normal \
        --enable-static --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
    if [ "$(BUILD_SHARED)" = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(1)/lib/libncurses.a'; \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/'; \
      $(INSTALL) -m755 '$(1)/lib/libncurses.dll.a' '$(PREFIX)/$(TARGET)/lib/libncurses.dll.a'; \
      $(INSTALL) -m755 '$(1)/lib/libncurses.dll' '$(PREFIX)/$(TARGET)/bin/libncurses.dll'; \
    fi
endef
