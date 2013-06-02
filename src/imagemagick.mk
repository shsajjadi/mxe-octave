# This file is part of MXE.
# See index.html for further information.

PKG             := imagemagick
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 13198d502e95abb305c23c3d56378e9139fcb7c3
$(PKG)_SUBDIR   := ImageMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := ImageMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.nluug.nl/ImageMagick/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 ffmpeg fftw freetype jasper jpeg lcms libpng libtool openexr pthreads tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.imagemagick.org/' | \
    $(SED) -n 's,.*<p>The current release is ImageMagick \([0-9][^<]*\).</p>.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --with-x=no \
        --without-zlib \
        ac_cv_prog_freetype_config='$(HOST_BINDIR)/freetype-config'
    $(SED) -i 's/#define MAGICKCORE_ZLIB_DELEGATE 1//g' '$(1)/magick/magick-config.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS=
endef
