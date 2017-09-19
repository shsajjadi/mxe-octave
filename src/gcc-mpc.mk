# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-mpc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2
$(PKG)_CHECKSUM := 5072d82ab50ec36cc8c0e320b5c377adb48abe70
$(PKG)_SUBDIR   := mpc-$($(PKG)_VERSION)
$(PKG)_FILE     := mpc-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.multiprecision.org/mpc/download/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.debian.org/debian/pool/main/m/mpclib/mpclib_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_DEPS     := gcc-gmp gcc-mpfr

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $(mpc_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --disable-shared \
        --with-gmp='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
