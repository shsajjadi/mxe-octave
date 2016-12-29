# This file is part of MXE.
# See index.html for further information.

PKG             := wxwidgets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.2
$(PKG)_CHECKSUM := 6461eab4428c0a8b9e41781b8787510484dea800
$(PKG)_SUBDIR   := wxWidgets-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/wxwindows/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := libiconv libpng jpeg tiff sdl zlib expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/wxwindows/files/' | \
    $(SED) -n 's,.*/\([0-9][^"9]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD

    # build the wxWidgets variant without unicode support
    cd '$(1)' && ./configure \
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

    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=

    $(INSTALL) -m755 '$(HOST_BINDIR)/wx-config' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)wx-config'
    mv $(HOST_LIBDIR)/wxbase30*.dll $(HOST_BINDIR)/
    mv $(HOST_LIBDIR)/wxmsw30*.dll $(HOST_BINDIR)/

endef
