# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-gmp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.1.2
$(PKG)_CHECKSUM := 366ded6a44cd108ba6b3f5b9a252eab3f3a95cdf
$(PKG)_SUBDIR   := gmp-$($(PKG)_VERSION)
$(PKG)_FILE     := gmp-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gmplib.org/download/gmp/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $(gmp_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --disable-shared
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
