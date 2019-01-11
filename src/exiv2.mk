# This file is part of MXE.
# See index.html for further information.

PKG             := exiv2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.23
$(PKG)_CHECKSUM := 5f342bf642477526f41add11d6ee7787cdcd639f
$(PKG)_SUBDIR   := exiv2-$($(PKG)_VERSION)
$(PKG)_FILE     := exiv2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.exiv2.org/$($(PKG)_FILE)
$(PKG)_DEPS     := libiconv zlib expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.exiv2.org/archive.html' | \
    grep 'href="/releases/exiv2-' | \
    $(SED) -n 's,.*exiv2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-visibility \
        --disable-nls \
        --with-expat
    $(MAKE) -C '$(1)/xmpsdk/src' -j '$(JOBS)'
    $(MAKE) -C '$(1)/src'        -j '$(JOBS)' install-lib
endef
