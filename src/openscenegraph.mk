# This file is part of MXE.
# See index.html for further information.

PKG             := openscenegraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.0
$(PKG)_CHECKSUM := c20891862b5876983d180fc4a3d3cfb2b4a3375c
$(PKG)_SUBDIR   := OpenSceneGraph-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenSceneGraph-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://www.openscenegraph.org/downloads/developer_releases/$($(PKG)_FILE)
$(PKG)_DEPS     := boost curl dcmtk ffmpeg freetype gdal giflib gta jasper jpeg libpng openal openexr poppler qt tiff xine-lib zlib

ifeq ($(BUILD_SHARED),yes)
    $(PKG)_SHARED := ON
else
    $(PKG)_SHARED := OFF
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openscenegraph.org/index.php/download-section/stable-releases' | \
    $(SED) -n 's,.*OpenSceneGraph/tree/OpenSceneGraph-\([0-9]*\.[0-9]*[02468]\.[^<]*\)">.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir -p '$(1)/.build'
    cd '$(1)/.build' && cmake .. \
        $(CMAKE_CCACHE_FLAGS) \
        $(CMAKE_BUILD_SHARED_OR_STATIC) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_CXX_FLAGS=-D__STDC_CONSTANT_MACROS \
        -DCMAKE_HAVE_PTHREAD_H=ON \
        -DPKG_CONFIG_EXECUTABLE='$(MXE_PKG_CONFIG)' \
        -DDYNAMIC_OPENTHREADS=$($(PKG)_SHARED) \
        -DDYNAMIC_OPENSCENEGRAPH=$($(PKG)_SHARED) \
        -DBUILD_OSG_APPLICATIONS=OFF \
        -DPOPPLER_HAS_CAIRO_EXITCODE=0 \
        -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 \
        -D_OPENTHREADS_ATOMIC_USE_WIN32_INTERLOCKED_EXITCODE=0
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1)/.build' -j 1 install
endef

