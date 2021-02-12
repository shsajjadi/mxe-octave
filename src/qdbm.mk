# This file is part of MXE.
# See index.html for further information.

PKG             := qdbm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.78
$(PKG)_CHECKSUM := 8c2ab938c2dad8067c29b0aa93efc6389f0e7076
$(PKG)_SUBDIR   := qdbm-$($(PKG)_VERSION)
$(PKG)_FILE     := qdbm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://fallabs.com/qdbm/qdbm-1.8.78.tar.gz
$(PKG)_DEPS     := bzip2 libiconv lzo zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://fallabs.com/qdbm/' | \
    grep 'qdbm-' | \
    $(SED) -n 's,.*qdbm-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --enable-lzo \
        --enable-bzip \
        --enable-zlib \
        --enable-iconv
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        static \
        MYBINS= \
        MYLIBS=libqdbm.a \
        AR=i686-pc-mingw32-ar \
        RANLIB=i686-pc-mingw32-ranlib
    $(INSTALL) -d '$(HOST_LIBDIR)/pkgconfig'
    $(INSTALL) -m644 '$(1)/libqdbm.a' '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/qdbm.pc'   '$(HOST_LIBDIR)/pkgconfig/'
    $(INSTALL) -d '$(HOST_INCDIR)'
    cd '$(1)' && $(INSTALL) -m644 depot.h curia.h relic.h hovel.h \
        cabin.h villa.h vista.h odeum.h '$(HOST_INCDIR)'

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-qdbm.exe' \
        `'$(MXE_PKG_CONFIG)' qdbm --cflags --libs`
endef
