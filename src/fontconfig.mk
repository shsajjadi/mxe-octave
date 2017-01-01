# This file is part of MXE.
# See index.html for further information.

PKG             := fontconfig
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.12.1
$(PKG)_CHECKSUM := 30d832b754fb10a3b70ebac750a38a0275438ad8
$(PKG)_SUBDIR   := fontconfig-$($(PKG)_VERSION)
$(PKG)_FILE     := fontconfig-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://fontconfig.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := freetype expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://fontconfig.org/release/' | \
    $(SED) -n 's,.*fontconfig-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        FREETYPE_CFLAGS='-I$(HOST_INCDIR)/freetype2' \
        FREETYPE_LIBS='-lfreetype' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-arch='$(TARGET)' \
        --disable-docs \
        --with-expat='$(HOST_PREFIX)' && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install sbin_PROGRAMS= noinst_PROGRAMS=
endef
