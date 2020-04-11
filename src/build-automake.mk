# This file is part of MXE.
# See index.html for further information.

PKG             := build-automake
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.2
$(PKG)_CHECKSUM := dbfc7e802a2f4a333cc406abe6f9e4df6260f0e3
$(PKG)_SUBDIR   := automake-$($(PKG)_VERSION)
$(PKG)_FILE     := automake-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/automake/$($(PKG)_FILE)
$(PKG)_DEPS     := build-autoconf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/automake/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="automake-\([0-9\.]*\)\.tar.*,\1,p' | \
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
