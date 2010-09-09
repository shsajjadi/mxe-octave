# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# wxWidgets
PKG             := wxwidgets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.11
$(PKG)_CHECKSUM := fa31e7fdb972baa28d89a7196391a9c1371e5f0e
$(PKG)_SUBDIR   := wxMSW-$($(PKG)_VERSION)
$(PKG)_FILE     := wxMSW-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.wxwidgets.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/wxwindows/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv libpng jpeg tiff sdl zlib expat

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/wxwindows/files/?sort=date&sortdir=desc' | \
    $(SED) -n 's,.*/\([0-9][^"9]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,png_check_sig,png_sig_cmp,g'                       '$(1)/configure'
    $(SED) -i 's,wx_cv_cflags_mthread=yes,wx_cv_cflags_mthread=no,' '$(1)/configure'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
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
        --without-odbc
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/bin/$(TARGET)-wx-config'

    # build the wxWidgets variant without unicode support
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,wxwidgets)
    $(SED) -i 's,png_check_sig,png_sig_cmp,g'                       '$(1)/$(wxwidgets_SUBDIR)/configure'
    $(SED) -i 's,wx_cv_cflags_mthread=yes,wx_cv_cflags_mthread=no,' '$(1)/$(wxwidgets_SUBDIR)/configure'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/$(wxwidgets_SUBDIR)/configure'
    cd '$(1)/$(wxwidgets_SUBDIR)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
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
        --without-odbc
    $(MAKE) -C '$(1)/$(wxwidgets_SUBDIR)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # backup of the unicode wx-config script
    # such that "make install" won't overwrite it
    mv '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/$(TARGET)/bin/wx-config-backup'

    $(MAKE) -C '$(1)/$(wxwidgets_SUBDIR)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=
    mv '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/$(TARGET)/bin/wx-config-nounicode'
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/wx-config-nounicode' '$(PREFIX)/bin/$(TARGET)-wx-config-nounicode'

    # restore the unicode wx-config script
    mv '$(PREFIX)/$(TARGET)/bin/wx-config-backup' '$(PREFIX)/$(TARGET)/bin/wx-config'
endef
