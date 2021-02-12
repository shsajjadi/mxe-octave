# This file is part of MXE.
# See index.html for further information.

PKG             := xine-lib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.4
$(PKG)_CHECKSUM := 32267c5fcaa1439a5fbf7606d27dc4fafba9e504
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/xine/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
ifeq ($(USE_SYSTEM_FONTCONFIG),no)
  $(PKG)_FONTCONFIG := fontconfig
endif
$(PKG)_DEPS     := faad2 ffmpeg flac $($(PKG)_FONTCONFIG) freetype graphicsmagick libiconv libmng pthreads sdl speex theora vorbis wavpack zlib libmpcdec libcdio vcdimager mman-win32 libmad a52dec libmodplug

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/p/xine/xine-lib-1.2/ref/default/tags/' | \
    $(SED) -n 's,.*xine-lib-1.2/ci/\([0-9][^/]*\)/.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # rebuild configure script as one of the patches modifies configure.ac
    cd '$(1)' && aclocal -I m4
    cd '$(1)' && $(LIBTOOLIZE)
    cd '$(1)' && autoconf

    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-mmap \
        --disable-nls \
        --disable-aalib \
        --enable-mng \
        --disable-real-codecs \
        --with-external-ffmpeg \
        --without-x \
        --with-sdl \
        --with-vorbis \
        --with-theora \
        --with-speex \
        --with-libflac \
        --without-external-a52dec \
        --without-external-libmad \
        --without-external-libmpcdec \
        --with-freetype \
        --with-fontconfig \
        --without-alsa \
        --without-esound \
        --without-arts \
        --without-fusionsound \
        --with-internal-vcdlibs \
        --with-external-libfaad \
        --without-external-libdts \
        --without-wavpack \
        CFLAGS='-I$(1)/win32/include' \
        PTHREAD_LIBS='-lpthread -lws2_32' \
        LIBS="`$(MXE_PKG_CONFIG) --libs libmng`"
    $(SED) -i 's,[\s^]*sed , $(SED) ,g' '$(1)/src/combined/ffmpeg/Makefile'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
