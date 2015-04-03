# This file is part of MXE.
# See index.html for further information.

PKG             := graphicsmagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.21
$(PKG)_CHECKSUM := bd3c543520b810999348e52d4abad6b59069f78b
$(PKG)_SUBDIR   := GraphicsMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := GraphicsMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib bzip2 jpeg jasper lcms libpng tiff freetype libxml2
ifneq ($(MXE_SYSTEM),msvc)
    $(PKG)_DEPS += pthreads libtool
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/graphicsmagick/files/graphicsmagick/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # This can be removed once the patch "graphicsmagick-1-fix-xml2-config.patch" is accepted by upstream
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
         $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --prefix='$(HOST_PREFIX)' \
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
        --with-ttf='$(HOST_PREFIX)' \
        --without-wmf \
        --with-xml \
        --with-zlib \
        --without-x \
        ac_cv_prog_xml2_config='$(HOST_BINDIR)/xml2-config' \
        ac_cv_path_xml2_config='$(HOST_BINDIR)/xml2-config' \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= DESTDIR='$(3)'
endef
