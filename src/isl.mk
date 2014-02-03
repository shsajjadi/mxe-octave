# This file is part of MXE.
# See index.html for further information.

PKG             := isl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.11.1
$(PKG)_CHECKSUM := d7936929c3937e03f09b64c3c54e49422fa8ddb3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gmp

# stick to tested versions from gcc
define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://gcc.gnu.org/pub/gcc/infrastructure/' | \
    $(SED) -n 's,.*isl-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-gmp-prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
