# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-isl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.22.1
$(PKG)_CHECKSUM := 125303d52bd6226f80d23bf1f76b78c6f1115568
$(PKG)_SUBDIR   := isl-$($(PKG)_VERSION)
$(PKG)_FILE     := isl-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://isl.gforge.inria.fr/$($(PKG)_FILE)
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
