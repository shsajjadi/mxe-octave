# This file is part of MXE.
# See index.html for further information.

PKG             := ffmpeg
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := bf1f917c4fa26cf225616f2063e60c33cac546be
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.ffmpeg.org/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := http://launchpad.net/ffmpeg/main/$($(PKG)_VERSION)/+download/$($(PKG)_FILE)
$(PKG)_DEPS     := bzip2 lame libvpx opencore-amr sdl speex theora vorbis x264 xvidcore zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.ffmpeg.org/download.html' | \
    $(SED) -n 's,.*ffmpeg-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    '$(SED)' -i "s^[-]lvpx^`'$(MXE_PKG_CONFIG)' --libs-only-l vpx`^g;" $(1)/configure
    cd '$(1)' && ./configure \
        --cross-prefix='$(MXE_TOOL_PREFIX)' \
        --enable-cross-compile \
        --arch=i686 \
        --target-os=mingw32 \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-debug \
        --disable-doc \
        --enable-memalign-hack \
        --enable-gpl \
        --enable-version3 \
        --disable-nonfree \
        --enable-postproc \
        --disable-pthreads \
        --enable-w32threads \
        --enable-avisynth \
        --enable-libspeex \
        --enable-libtheora \
        --enable-libvorbis \
        --enable-libmp3lame \
        --enable-libxvid \
        --disable-libfaac \
        --enable-libopencore-amrnb \
        --enable-libopencore-amrwb \
        --enable-libx264 \
        --enable-libvpx
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
