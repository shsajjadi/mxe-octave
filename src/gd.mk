# This file is part of MXE.
# See index.html for further information.

PKG             := gd
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.35
$(PKG)_CHECKSUM := ccf34a610abff2dbf133a20c4d2a4aa94939018a
$(PKG)_SUBDIR   := gd-$($(PKG)_VERSION)
$(PKG)_FILE     := gd-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.libgd.org/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.uni-magdeburg.de/aftp/mirror/linux/slackware/source/l/gd/$($(PKG)_FILE)
$(PKG)_DEPS     := freetype libpng jpeg libxml2 pthreads

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package gd.' >&2;
    echo $(gd_VERSION)
endef
define $(PKG)_UPDATE_orig
    $(WGET) -q -O- 'http://www.libgd.org/releases/' | \
    $(SED) -n 's,.*gd-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    touch '$(1)/aclocal.m4'
    touch '$(1)/config.hin'
    touch '$(1)/Makefile.in'
    $(SED) -i 's,-I@includedir@,-I@includedir@ -DNONDLL,' '$(1)/config/gdlib-config.in'
    $(SED) -i 's,-lX11 ,,g'     '$(1)/configure'
    $(SED) -i 's,png12,png15,g' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-freetype='$(HOST_PREFIX)' \
        --without-x \
        LIBPNG_CONFIG='$(HOST_BINDIR)/libpng-config' \
        CFLAGS='-DNONDLL -DXMD_H -L$(HOST_LIBDIR)' \
        LIBS="`$(HOST_BINDIR)/xml2-config --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-gd.exe' \
        `'$(HOST_BINDIR)/gdlib-config' --cflags` \
        -lgd `'$(HOST_BINDIR)/gdlib-config' --libs`
endef
