# This file is part of MXE.
# See index.html for further information.

PKG             := geos
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.7.1
$(PKG)_CHECKSUM := c06a2e7620b9197c6b9ac456395f4ee4fed9cb86
$(PKG)_SUBDIR   := geos-$($(PKG)_VERSION)
$(PKG)_FILE     := geos-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://download.osgeo.org/geos/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/geos/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.osgeo.org/geos/' | \
    $(SED) -n 's,.*geos-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
endef
