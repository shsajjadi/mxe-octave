# This file is part of MXE.
# See index.html for further information.

PKG             := cloog
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.4
$(PKG)_CHECKSUM := 8f7568ca1873f8d55bb694c8b9b83f7f4c6c1aa5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.bastoul.net/cloog/pages/download/$($(PKG)_FILE)
$(PKG)_DEPS     := build-gcc gmp isl

# stick to tested versions from gcc
define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://gcc.gnu.org/pub/gcc/infrastructure/' | \
    $(SED) -n 's,.*cloog-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-gmp-prefix='$(HOST_PREFIX)' \
        --with-isl-prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
