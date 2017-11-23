# This file is part of MXE.
# See index.html for further information.

PKG             := build-texinfo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.0
$(PKG)_CHECKSUM := 110d45256c4219c88dc2fdb8c9c1a20749e4e7c5
$(PKG)_SUBDIR   := texinfo-$($(PKG)_VERSION)
$(PKG)_FILE     := texinfo-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/texinfo/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/texinfo/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="texinfo-\([0-9\.]*\)\.tar.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)'

    $(MAKE) -C '$(1).build/gnulib/lib' -j '$(JOBS)'
    $(MAKE) -C '$(1).build/util' -j '$(JOBS)'
    $(MAKE) -C '$(1).build/tp' -j '$(JOBS)'

    $(MAKE) -C '$(1).build/gnulib/lib' -j 1 install DESTDIR='$(3)'
    $(MAKE) -C '$(1).build/util' -j 1 install DESTDIR='$(3)'
    $(MAKE) -C '$(1).build/tp' -j 1 install DESTDIR='$(3)'
endef
