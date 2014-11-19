# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-mpc
$(PKG)_IGNORE    = $(mpc_IGNORE)
$(PKG)_VERSION   = $(mpc_VERSION)
$(PKG)_CHECKSUM  = $(mpc_CHECKSUM)
$(PKG)_SUBDIR    = $(mpc_SUBDIR)
$(PKG)_FILE      = $(mpc_FILE)
$(PKG)_URL       = $(mpc_URL)
$(PKG)_URL_2     = $(mpc_URL_2)
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
