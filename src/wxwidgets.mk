# This file is part of MXE.
# See index.html for further information.

PKG             := wxwidgets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.2
$(PKG)_CHECKSUM := 6461eab4428c0a8b9e41781b8787510484dea800
$(PKG)_SUBDIR   := wxMSW-$($(PKG)_VERSION)
$(PKG)_FILE     := wxMSW-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/wxwindows/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := libiconv libpng jpeg tiff sdl zlib expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/wxwindows/files/' | \
    $(SED) -n 's,.*/\([0-9][^"9]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,png_check_sig,png_sig_cmp,g'                       '$(1)/configure'
    $(SED) -i 's,wx_cv_cflags_mthread=yes,wx_cv_cflags_mthread=no,' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-compat24 \
        --enable-compat26 \
        --enable-gui \
        --enable-stl \
        --enable-threads \
        --enable-unicode \
        --disable-universal \
        --with-themes=all \
        --with-msw \
        --with-opengl \
        --with-libpng=sys \
        --with-libjpeg=sys \
        --with-libtiff=sys \
        --with-regex=yes \
        --with-zlib=sys \
        --with-expat=sys \
        --with-sdl \
        --without-gtk \
        --without-motif \
        --without-mac \
        --without-macosx-sdk \
        --without-cocoa \
        --without-wine \
        --without-pm \
        --without-microwin \
        --without-libxpm \
        --without-libmspack \
        --without-gnomeprint \
        --without-gnomevfs \
        --without-hildon \
        --without-dmalloc \
        --without-odbc \
        LIBS=" `'$(MXE_PKG_CONFIG)' --libs-only-l libtiff-4`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    -$(MAKE) -C '$(1)/locale' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= allmo
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=
    $(INSTALL) -m755 '$(HOST_BINDIR)/wx-config' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)wx-config'

    # build the wxWidgets variant without unicode support
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,wxwidgets,$(TAR))
    $(foreach PKG_PATCH,$(sort $(wildcard $(TOP_DIR)/src/wxwidgets-*.patch)),
    (cd '$(1)/$(wxwidgets_SUBDIR)' && $(PATCH) -p1 -u) < $(PKG_PATCH))
    $(SED) -i 's,png_check_sig,png_sig_cmp,g'                       '$(1)/$(wxwidgets_SUBDIR)/configure'
    $(SED) -i 's,wx_cv_cflags_mthread=yes,wx_cv_cflags_mthread=no,' '$(1)/$(wxwidgets_SUBDIR)/configure'
    cd '$(1)/$(wxwidgets_SUBDIR)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-compat24 \
        --enable-compat26 \
        --enable-gui \
        --enable-stl \
        --enable-threads \
        --disable-unicode \
        --disable-universal \
        --with-themes=all \
        --with-msw \
        --with-opengl \
        --with-libpng=sys \
        --with-libjpeg=sys \
        --with-libtiff=sys \
        --with-regex=yes \
        --with-zlib=sys \
        --with-expat=sys \
        --with-sdl \
        --without-gtk \
        --without-motif \
        --without-mac \
        --without-macosx-sdk \
        --without-cocoa \
        --without-wine \
        --without-pm \
        --without-microwin \
        --without-libxpm \
        --without-libmspack \
        --without-gnomeprint \
        --without-gnomevfs \
        --without-hildon \
        --without-dmalloc \
        --without-odbc \
        LIBS=" `'$(MXE_PKG_CONFIG)' --libs-only-l libtiff-4`"
    $(MAKE) -C '$(1)/$(wxwidgets_SUBDIR)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # backup of the unicode wx-config script
    # such that "make install" won't overwrite it
    mv '$(HOST_BINDIR)/wx-config' '$(HOST_BINDIR)/wx-config-backup'

    $(MAKE) -C '$(1)/$(wxwidgets_SUBDIR)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=
    mv '$(HOST_BINDIR)/wx-config' '$(HOST_BINDIR)/wx-config-nounicode'
    $(INSTALL) -m755 '$(HOST_BINDIR)/wx-config-nounicode' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)wx-config-nounicode'

    # restore the unicode wx-config script
    mv '$(HOST_BINDIR)/wx-config-backup' '$(HOST_BINDIR)/wx-config'

    # build test program
    '$(MXE_CXX)' \
        -W -Wall -Werror -pedantic -std=gnu++0x \
        '$(2).cpp' -o '$(HOST_BINDIR)/test-wxwidgets.exe' \
        `'$(MXE_TOOL_PREFIX)wx-config' --cflags --libs`
endef
