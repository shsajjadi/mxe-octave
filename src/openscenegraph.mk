# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# OpenSceneGraph
PKG             := openscenegraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.0
$(PKG)_CHECKSUM := aa4982bf1502c8ad52b40508221978a2ca48e34e
$(PKG)_SUBDIR   := OpenSceneGraph-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenSceneGraph-$($(PKG)_VERSION).zip
$(PKG)_WEBSITE  := http://www.openscenegraph.org/
$(PKG)_URL      := http://www.openscenegraph.org/downloads/stable_releases/OpenSceneGraph-3.0/source/$($(PKG)_FILE)
$(PKG)_URL_2    := http://distfiles.macports.org/OpenSceneGraph/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc curl ffmpeg freetype gdal giflib jasper jpeg libpng openexr tiff xine-lib zlib dcmtk

define $(PKG)_UPDATE
    wget -q -O- 'http://www.openscenegraph.org/projects/osg/browser/OpenSceneGraph/tags?order=date&desc=1' | \
    grep '<a ' | \
    $(SED) -n 's,.*>OpenSceneGraph-\([0-9][^<]*\)<.*,\1,p' | \
    grep -v '^2\.9\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_CXX_FLAGS=-D__STDC_CONSTANT_MACROS \
        -DCMAKE_HAVE_PTHREAD_H=OFF \
        -DDYNAMIC_OPENTHREADS=OFF \
        -DDYNAMIC_OPENSCENEGRAPH=OFF \
        -DBUILD_OSG_APPLICATIONS=OFF \
        -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef
