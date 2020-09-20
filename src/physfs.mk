# This file is part of MXE.
# See index.html for further information.

PKG             := physfs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.3
$(PKG)_CHECKSUM := 327308c777009a41bbabb9159b18c4c0ac069537
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := http://icculus.org/physfs/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://icculus.org/physfs/downloads/?M=D' | \
    $(SED) -n 's,.*<a href="physfs-\([0-9][^"]*\)\.tar.*,\1,pI' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        $(CMAKE_CCACHE_FLAGS) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DPHYSFS_BUILD_SHARED=FALSE \
        -DPHYSFS_INTERNAL_ZLIB=FALSE \
        -DPHYSFS_BUILD_TEST=FALSE \
        -DPHYSFS_BUILD_WX_TEST=FALSE
        $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(2).c' -o '$(HOST_BINDIR)/test-physfs.exe' \
        -lphysfs -lz
endef
