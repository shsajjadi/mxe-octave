# This file is part of MXE.
# See index.html for further information.

PKG             := xvidcore
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 56e065d331545ade04c63c91153b9624b51d6e1b
$(PKG)_SUBDIR   := xvidcore/build/generic
$(PKG)_FILE     := xvidcore-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xvid.org/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.xvid.org/' | \
    $(SED) -n 's,.*Xvid \([0-9][^ ]*\) .*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' BUILD_DIR='build' SHARED_LIB=
    $(INSTALL) -d '$(HOST_PREFIX)/include'
    $(INSTALL) -m644 '$(1)/../../src/xvid.h' '$(HOST_PREFIX)/include/'
    $(INSTALL) -d '$(HOST_PREFIX)/lib'
    $(INSTALL) -m644 '$(1)/build/xvidcore.a' '$(HOST_PREFIX)/lib/'
    $(LN_SF) '$(HOST_PREFIX)/lib/xvidcore.a' '$(HOST_PREFIX)/lib/libxvidcore.a'
endef
