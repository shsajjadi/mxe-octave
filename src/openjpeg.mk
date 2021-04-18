# This file is part of MXE.
# See index.html for further information.

PKG             := openjpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.0
$(PKG)_CHECKSUM := bbbf4dc4d9ce95286843cd39ac2febd3fd516c9d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/uclouvain/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := lcms libpng tiff zlib

$(PKG)_CMAKE_FLAGS :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/uclouvain/openjpeg/tags' | \
    $(SED) -n 's|.*releases/tag/v\([0-9][^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        $($(PKG)_CMAKE_FLAGS) \
        -DBUILD_PKGCONFIG_FILES=ON \
        -DBUILD_TESTING=OFF \
        $(CMAKE_CCACHE_FLAGS) \
        $(CMAKE_BUILD_SHARED_OR_STATIC) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        .

    $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1)' -j '1' VERBOSE=1 DESTDIR='$(3)' install
endef
