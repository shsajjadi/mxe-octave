# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-isl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.16.1
$(PKG)_CHECKSUM := c5a2b201bf05229647e73203c0bf2d9679d4d21f
$(PKG)_SUBDIR   := isl-$($(PKG)_VERSION)
$(PKG)_FILE     := isl-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc-gmp

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $(isl_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --disable-shared \
        --with-gmp-prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
