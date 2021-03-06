# This file is part of MXE.
# See index.html for further information.

PKG             := cminpack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.0
$(PKG)_CHECKSUM := 8bf19ce37b486707c402a046c33d823c9e359410
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://devernay.free.fr/hacks/cminpack/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://devernay.free.fr/hacks/cminpack/index.html' | \
    $(SED) -n 's,.*cminpack-\([0-9.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        $(CMAKE_CCACHE_FLAGS) \
        $(CMAKE_BUILD_SHARED_OR_STATIC) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)' -j $(JOBS)

    $(INSTALL) -d                         '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/libcminpack.a' '$(HOST_LIBDIR)'
    $(INSTALL) -d                         '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/cminpack.h'    '$(HOST_INCDIR)'
endef
