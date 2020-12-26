# This file is part of MXE.
# See index.html for further information.

PKG             := gtkglext
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := db9ce38ee555fd14f55083ec7f4ae30e5338d5cc
$(PKG)_SUBDIR   := gtkglext-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglext-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gtkglext/gtkglext/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gtk2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnome.org/pub/gnome/sources/gtkglext/1.2/' | \
    $(SED) -n 's,.*gtkglext-\(1[^>]*\)\.tar.*,\1,ip' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --without-x \
        --with-gdktarget=win32 \
        --disable-gtk-doc \
        --disable-man \
        --disable-glibtest
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        INFO_DEPS= \
        GDKGLEXT_DEP_CFLAGS='`'$(MXE_PKG_CONFIG)' gtk+-2.0 --cflags`' \
        GTKGLEXT_DEP_CFLAGS='`'$(MXE_PKG_CONFIG)' gtk+-2.0 --cflags`'

    '$(MXE_CC)' \
        -W -Wall -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-gtkglext.exe' \
        `'$(MXE_PKG_CONFIG)' gtkglext-1.0 --cflags --libs`
endef
