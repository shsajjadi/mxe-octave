# This file is part of MXE.
# See index.html for further information.

PKG             := graphicsmagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.36
$(PKG)_CHECKSUM := df45052bf485407ad4fb7d3b9b305d3e5ebb14e5
$(PKG)_SUBDIR   := GraphicsMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := GraphicsMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib bzip2 libjbig jpeg jasper lcms libpng tiff freetype libxml2
ifneq ($(MXE_SYSTEM),msvc)
    $(PKG)_DEPS += pthreads libtool
endif

$(PKG)_CONFIGURE_OPTIONS :=
ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_CONFIGURE_OPTIONS += ac_cv_func_clock_getres=no ac_cv_func_clock_gettime=no
endif


define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/graphicsmagick/files/graphicsmagick/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # This can be removed once the patch "graphicsmagick-1-fix-xml2-config.patch" is accepted by upstream
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $($(PKG)_CONFIGURE_OPTIONS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
         $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --prefix='$(HOST_PREFIX)' \
        --disable-openmp \
        --with-modules \
        --with-threads \
        --with-magick-plus-plus \
        --without-perl \
        --with-bzlib \
        --without-dps \
        --without-fpx \
        --without-gslib \
        --with-jbig \
        --with-jpeg \
        --with-jp2 \
        --with-lcms2 \
        --with-png \
        --with-tiff \
        --without-trio \
        --with-ttf='$(HOST_PREFIX)' \
        --without-wmf \
        --with-xml \
        --with-zlib \
        --without-x \
       --with-quantum-depth=16 \
        ac_cv_prog_xml2_config='$(HOST_BINDIR)/xml2-config' \
        ac_cv_path_xml2_config='$(HOST_BINDIR)/xml2-config' \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= DESTDIR='$(3)'

    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
      rm -rf "$(3)$(HOST_PREFIX)/share/doc/GraphicsMagick"; \
    fi
endef
