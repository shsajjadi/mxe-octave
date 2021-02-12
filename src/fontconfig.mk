# This file is part of MXE.
# See index.html for further information.

PKG             := fontconfig
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.13.1
$(PKG)_CHECKSUM := 75612356ef4f801735b49baf987f8942b4a7a5e1
$(PKG)_SUBDIR   := fontconfig-$($(PKG)_VERSION)
$(PKG)_FILE     := fontconfig-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://fontconfig.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := freetype expat gettext libiconv
ifeq ($(MXE_WINDOWS_BUILD),no)
  $(PKG)_DEPS += util-linux
endif

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

    $(MAKE) -C '$(1)' -j 1 fonts.conf
    $(SED) -i "\|^.*<cachedir>$(HOST_PREFIX).*$$|d" $(1)/fonts.conf

    $(MAKE) -C '$(1)' -j 1 install sbin_PROGRAMS= noinst_PROGRAMS=
endef
