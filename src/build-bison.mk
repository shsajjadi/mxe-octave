# This file is part of MXE.
# See index.html for further information.

PKG             := build-bison
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.5.4
$(PKG)_CHECKSUM := 67279a74698e60093f57e1dec8e6236e0b194bb2
$(PKG)_SUBDIR   := bison-$($(PKG)_VERSION)
$(PKG)_FILE     := bison-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/bison/$($(PKG)_FILE)
$(PKG)_DEPS     := build-xz

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/bison/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="bison-\([0-9\.]*\)\.tar.*,\1,p' | \
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
