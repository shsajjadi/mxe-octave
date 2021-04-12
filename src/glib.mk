# This file is part of MXE.
# See index.html for further information.

PKG             := glib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.54.0
$(PKG)_CHECKSUM := 96b434a9ca142344b93f38ed0cd88d36196b68ae
$(PKG)_SUBDIR   := glib-$($(PKG)_VERSION)
$(PKG)_FILE     := glib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/glib/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext pcre libiconv zlib libffi dbus

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/GNOME/glib/tags' | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_SYMLINK
    $(LN_SF) `which glib-genmarshal`        '$(HOST_BINDIR)'
    $(LN_SF) `which glib-compile-schemas`   '$(HOST_BINDIR)'
    $(LN_SF) `which glib-compile-resources` '$(HOST_BINDIR)'
endef

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
define $(PKG)_BUILD
    cd $(1) && NOCONFIGURE=true ./autogen.sh
    cd '$(1)' && PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-threads=win32 \
        --enable-regex \
        --disable-threads \
        --disable-selinux \
        --disable-inotify \
        --disable-fam \
        --disable-xattr \
        --disable-dtrace \
        --disable-libmount \
        --with-libiconv=gnu \
        --with-pcre=internal \
	&& $(CONFIGURE_POST_HOOK)

    $(SED) -i 's,#define G_ATOMIC.*,,' '$(1)/config.h'
    $(MAKE) -C '$(1)/glib'    -j '$(JOBS)'
    $(MAKE) -C '$(1)/gthread' -j '$(JOBS)'
    $(MAKE) -C '$(1)/gmodule' -j '$(JOBS)'
    $(MAKE) -C '$(1)/gobject' -j '$(JOBS)' lib_LTLIBRARIES= install-exec
    $(MAKE) -C '$(1)/gio/xdgmime'     -j '$(JOBS)'
    $(MAKE) -C '$(1)/gio'     -j '$(JOBS)' glib-compile-schemas
    $(MAKE) -C '$(1)/gio'     -j '$(JOBS)' glib-compile-resources
    $(INSTALL) -m755 '$(1)/gio/glib-compile-schemas' '$(HOST_BINDIR)/'
    $(INSTALL) -m755 '$(1)/gio/glib-compile-resources' '$(HOST_BINDIR)/'
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
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        PKG_CONFIG_PATH='$(PKG_CONFIG_PATH)' 

    $(MAKE) -C '$(1)/glib'    -j '$(JOBS)' install sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gmodule' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gthread' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gobject' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gio'     -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= MISC_STUFF=
    $(MAKE) -C '$(1)'         -j '$(JOBS)' install-pkgconfigDATA
    $(MAKE) -C '$(1)/m4macros' install
endef

endif
