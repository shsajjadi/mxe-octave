# This file is part of MXE.
# See index.html for further information.

PKG             := build-gperf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.4
$(PKG)_CHECKSUM := e32d4aff8f0c730c9a56554377b2c6d82d0951b8
$(PKG)_SUBDIR   := gperf-$($(PKG)_VERSION)
$(PKG)_FILE     := gperf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gperf/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gperf/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gperf-\([0-9\.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install DESTDIR='$(3)'
endef
