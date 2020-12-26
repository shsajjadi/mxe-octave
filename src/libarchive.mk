# This file is part of MXE.
# See index.html for further information.

PKG             := libarchive
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.3
$(PKG)_CHECKSUM := b774e2675e5c1abafbd4d667402e8c3e72313944
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://libarchive.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := bzip2 libiconv libxml2 openssl xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.libarchive.org/downloads/' | \
    $(SED) -n 's,.*libarchive-\([0-9][^<]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i '1i#ifndef LIBARCHIVE_STATIC\n#define LIBARCHIVE_STATIC\n#endif' -i '$(1)/libarchive/archive.h'
    $(SED) -i '1i#ifndef LIBARCHIVE_STATIC\n#define LIBARCHIVE_STATIC\n#endif' -i '$(1)/libarchive/archive_entry.h'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-bsdtar \
        --disable-bsdcpio \
        XML2_CONFIG='$(HOST_BINDIR)'/xml2-config
    $(MAKE) -C '$(1)' -j '$(JOBS)' man_MANS=
    $(MAKE) -C '$(1)' -j 1 install man_MANS=

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-libarchive.exe' \
        `'$(MXE_PKG_CONFIG)' --libs-only-l libarchive`
endef
