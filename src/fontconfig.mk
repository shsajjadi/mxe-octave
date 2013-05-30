# This file is part of MXE.
# See index.html for further information.

PKG             := fontconfig
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c51c9865047a9546f41cedefbf955cc9bd846517
$(PKG)_SUBDIR   := fontconfig-$($(PKG)_VERSION)
$(PKG)_FILE     := fontconfig-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://fontconfig.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://fontconfig.org/release/' | \
    $(SED) -n 's,.*fontconfig-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        FREETYPE_CFLAGS='-I$(PREFIX)/$(TARGET)/include/freetype2' \
        FREETYPE_LIBS='-lfreetype' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-arch='$(TARGET)' \
        --disable-docs \
        --with-expat='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install sbin_PROGRAMS= noinst_PROGRAMS=
endef
