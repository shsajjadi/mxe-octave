# This file is part of MXE.
# See index.html for further information.

PKG             := graphicsmagick
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 6428eb4bd19635c833750ac9d56c9b89bef4c975
$(PKG)_SUBDIR   := GraphicsMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := GraphicsMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads libtool zlib bzip2 jpeg jasper lcms1 libpng tiff freetype libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/graphicsmagick/files/graphicsmagick/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # This can be removed once the patch "graphicsmagick-1-fix-xml2-config.patch" is accepted by upstream
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-modules \
        --with-threads \
        --with-magick-plus-plus \
        --without-perl \
        --with-bzlib \
        --without-dps \
        --without-fpx \
        --without-gslib \
        --without-jbig \
        --with-jpeg \
        --with-jp2 \
        --with-lcms \
        --with-png \
        --with-tiff \
        --without-trio \
        --with-ttf='$(PREFIX)/$(TARGET)' \
        --without-wmf \
        --with-xml \
        --with-zlib \
        --without-x \
        ac_cv_prog_xml2_config='$(PREFIX)/$(TARGET)/bin/xml2-config' \
        ac_cv_path_xml2_config='$(PREFIX)/$(TARGET)/bin/xml2-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS=

    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
 \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick.a' -ljpeg -ljasper -llzma -ltiff -llcms -lpng -lfreetype -lxml2 -lm; \
      $(INSTALL) -m644 '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick.dll.a' '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick.dll.a'; \
      $(INSTALL) -m644 '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick.dll' '$(PREFIX)/$(TARGET)/bin/libGraphicsMagick.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick.la'; \
 \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-g++' '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick++.a' -lGraphicsMagick -ljpeg -ljasper -llzma -ltiff -llcms -lpng -lfreetype -lxml2 -lm; \
      $(INSTALL) -m644 '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick++.dll.a' '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick++.dll.a'; \
      $(INSTALL) -m644 '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick++.dll' '$(PREFIX)/$(TARGET)/bin/libGraphicsMagick++.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick++.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libGraphicsMagick++.la'; \
 \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libGraphicsMagickWand.a' -lGraphicsMagick -ljpeg -ljasper -llzma -ltiff -llcms -lpng -lfreetype -lxml2 -lm; \
      $(INSTALL) -m644 '$(PREFIX)/$(TARGET)/lib/libGraphicsMagickWand.dll.a' '$(PREFIX)/$(TARGET)/lib/libGraphicsMagickWand.dll.a'; \
      $(INSTALL) -m644 '$(PREFIX)/$(TARGET)/lib/libGraphicsMagickWand.dll' '$(PREFIX)/$(TARGET)/bin/libGraphicsMagickWand.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libGraphicsMagickWand.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libGraphicsMagickWand.la'; \
    fi

##    '$(TARGET)-g++' \
##        -W -Wall -Werror -pedantic -std=gnu++0x \
##        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-graphicsmagick.exe' \
##        `'$(TARGET)-pkg-config' GraphicsMagick++ --cflags --libs`
endef
