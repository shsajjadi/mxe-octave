# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-mpc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := b019d9e1d27ec5fb99497159d43a3164995de2d0
$(PKG)_SUBDIR   := mpc-$($(PKG)_VERSION)
$(PKG)_FILE     := mpc-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/mpc/$($(PKG)_FILE)
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
