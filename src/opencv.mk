# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencv
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.3
$(PKG)_CHECKSUM := d700348b3251552ccf034e4d7dd16080e4086840
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := opencv-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)library/$(PKG)-unix/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://distfiles.macports.org/opencv/$($(PKG)_FILE)
$(PKG)_DEPS     := eigen ffmpeg jasper jpeg libpng \
                   openblas openexr tiff xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

# -DCMAKE_CXX_STANDARD=98 required for non-posix gcc7 build

define $(PKG)_BUILD
    # build
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake ..  \
        $(CMAKE_CCACHE_FLAGS) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        --debug-output \
        -DBUILD_opencv_dnn=OFF \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_python=OFF \
        -DWITH_QT=OFF \
        -DWITH_OPENGL=ON \
        -DWITH_GSTREAMER=OFF \
        -DWITH_GTK=OFF \
        -DWITH_VIDEOINPUT=ON \
        -DWITH_XINE=OFF \
        -DWITH_PYTHON=OFF \
        -DWITH_PROTOBUF=OFF \
        -DWITH_CUDA=OFF \
        -DBUILD_opencv_apps=OFF \
        -DBUILD_DOCS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_PACKAGE=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_WITH_DEBUG_INFO=OFF \
        -DBUILD_FAT_JAVA_LIB=OFF \
        -DBUILD_ZLIB=OFF \
        -DBUILD_TIFF=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_JPEG=OFF \
        -DBUILD_WEBP=ON \
        -DBUILD_PROTOBUF=OFF \
        -DPROTOBUF_UPDATE_FILES=ON \
        -DBUILD_PNG=OFF \
        -DBUILD_OPENEXR=OFF \
        -DCMAKE_VERBOSE=ON \
        -DCMAKE_CXX_STANDARD=11 \
        -DCMAKE_CXX_FLAGS='-D_WIN32_WINNT=0x0500'

    # install
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1)/build' -j 1 install VERBOSE=1

endef
