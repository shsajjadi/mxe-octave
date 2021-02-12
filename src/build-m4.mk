# This file is part of MXE.
# See index.html for further information.

PKG             := build-m4
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.18
$(PKG)_CHECKSUM := 2f76f8105a45b05c8cfede97b3193cd88b31c657
$(PKG)_SUBDIR   := m4-$($(PKG)_VERSION)
$(PKG)_FILE     := m4-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/m4/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/m4/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="m4-\([0-9\.]*\)\.tar.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install DESTDIR='$(3)'
endef
