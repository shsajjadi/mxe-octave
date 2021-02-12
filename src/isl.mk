# This file is part of MXE.
# See index.html for further information.

PKG             := isl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.22.1
$(PKG)_CHECKSUM := 125303d52bd6226f80d23bf1f76b78c6f1115568
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://isl.gforge.inria.fr/$($(PKG)_FILE)
$(PKG)_DEPS     := build-gcc gmp

$(PKG)_EXTRA_MAKE_FLAGS := LDFLAGS='-no-undefined'

# stick to tested versions from gcc
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://isl.gforge.inria.fr/' | \
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
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_EXTRA_MAKE_FLAGS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_EXTRA_MAKE_FLAGS) install
endef
