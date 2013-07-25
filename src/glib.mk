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

define $(PKG)_NATIVE_BUILD
    cp -Rp '$(1)' '$(1).native'

    # native build of libiconv (used by glib-genmarshal)
    cd '$(1).native' && $(call UNPACK_PKG_ARCHIVE,libiconv,$(TAR))
    cd '$(1).native/$(libiconv_SUBDIR)' && ./configure \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-nls
    $(MAKE) -C '$(1).native/$(libiconv_SUBDIR)' -j '$(JOBS)'

    # native build for glib-genmarshal, without pkg-config, gettext and zlib
    cd '$(1).native' && ./configure \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-regex \
        --disable-threads \
        --disable-selinux \
        --disable-inotify \
        --disable-fam \
        --disable-xattr \
        --disable-dtrace \
        --with-libiconv=gnu \
        --with-pcre=internal \
        CPPFLAGS='-I$(1).native/$(libiconv_SUBDIR)/include' \
        LDFLAGS='-L$(1).native/$(libiconv_SUBDIR)/lib/.libs'
    $(SED) -i 's,#define G_ATOMIC.*,,' '$(1).native/config.h'
    $(MAKE) -C '$(1).native/glib'    -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gthread' -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gmodule' -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gobject' -j '$(JOBS)' lib_LTLIBRARIES= install-exec
    $(MAKE) -C '$(1).native/gio/xdgmime'     -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gio'     -j '$(JOBS)' glib-compile-schemas
    $(MAKE) -C '$(1).native/gio'     -j '$(JOBS)' glib-compile-resources
    $(INSTALL) -m755 '$(1).native/gio/glib-compile-schemas' '$(HOST_BINDIR)'
    $(INSTALL) -m755 '$(1).native/gio/glib-compile-resources' '$(HOST_BINDIR)'
endef

define $(PKG)_SYMLINK
    $(LN_SF) `which glib-genmarshal`        '$(HOST_BINDIR)'
    $(LN_SF) `which glib-compile-schemas`   '$(HOST_BINDIR)'
    $(LN_SF) `which glib-compile-resources` '$(HOST_BINDIR)'
endef

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
define $(PKG)_BUILD
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
    cd '$(1)' && ./autogen.sh
    rm -f '$(HOST_BINDIR)/glib-*'
    $(if $(findstring y,\
            $(shell [ -x "`which glib-genmarshal`" ] && \
                    [ -x "`which glib-compile-schemas`" ] && \
                    [ -x "`which glib-compile-resources`" ] && echo y)), \
        $($(PKG)_SYMLINK), \
        $($(PKG)_NATIVE_BUILD))
    # cross build
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-threads=win32 \
        --with-pcre=system \
        --with-libiconv=gnu \
        --disable-inotify \
        CXX='$(MXE_CXX)' \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        GLIB_GENMARSHAL='$(HOST_BINDIR)/glib-genmarshal' \
        GLIB_COMPILE_SCHEMAS='$(HOST_BINDIR)/glib-compile-schemas' \
        GLIB_COMPILE_RESOURCES='$(HOST_BINDIR)/glib-compile-resources'
    $(MAKE) -C '$(1)/glib'    -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gmodule' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gthread' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gobject' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gio'     -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= MISC_STUFF=
    $(MAKE) -C '$(1)'         -j '$(JOBS)' install-pkgconfigDATA
endef
endif
