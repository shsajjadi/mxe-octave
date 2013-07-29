# This file is part of MXE.
# See index.html for further information.

PKG             := glib
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := aafba69934b9ba77cc8cb0e5d8105aa1d8463eba
$(PKG)_SUBDIR   := glib-$($(PKG)_VERSION)
$(PKG)_FILE     := glib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/glib/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext pcre libiconv zlib libffi dbus

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/glib/refs/tags' | \
    $(SED) -n "s,.*tag/?id=\([0-9]\+\.[0-9]*[02468]\.[^']*\).*,\1,p" | \
    head -1
endef

define $(PKG)_SYMLINK
    $(LN_SF) `which glib-genmarshal`        '$(HOST_BINDIR)'
    $(LN_SF) `which glib-compile-schemas`   '$(HOST_BINDIR)'
    $(LN_SF) `which glib-compile-resources` '$(HOST_BINDIR)'
endef

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
define $(PKG)_BUILD
    cd $(1) && ./autogen.sh
    cd '$(1)' && PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-threads=win32 \
        --with-pcre=system \
        --with-libiconv=gnu \
        --disable-modular-tests \
	&& $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
else
define $(PKG)_BUILD
    cd '$(1)' && NOCONFIGURE=true ./autogen.sh
    rm -f '$(HOST_BINDIR)/glib-*'
    # cross build
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --prefix='$(HOST_PREFIX)' \
        --with-threads=win32 \
        --with-pcre=system \
        --with-libiconv=gnu \
        --disable-inotify \
        --disable-modular-tests \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' 

    $(MAKE) -C '$(1)'    -j '$(JOBS)' 
    $(MAKE) -C '$(1)'    -j 1 install 
endef

endif
