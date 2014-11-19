# This file is part of MXE.
# See index.html for further information.

PKG             := poppler
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.20.5
$(PKG)_CHECKSUM := 5eb351381e6d7994bdf7f09bb5c1075f41d79381
$(PKG)_SUBDIR   := poppler-$($(PKG)_VERSION)
$(PKG)_FILE     := poppler-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://poppler.freedesktop.org/$($(PKG)_FILE)
$(PKG)_DEPS     := glib cairo libpng lcms jpeg tiff freetype zlib curl qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://poppler.freedesktop.org/' | \
    $(SED) -n 's,.*"poppler-\([0-9.]\+\)\.tar\.xz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Note: Specifying LIBS explicitly is necessary for configure to properly
    #       pick up libtiff (otherwise linking a minimal test program fails not
    #       because libtiff is not found, but because some references are
    #       undefined)
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --disable-silent-rules \
        $(ENABLE_SHARED_OR_STATIC) \
        --enable-xpdf-headers \
        --enable-poppler-qt4 \
        --enable-zlib \
        --enable-libcurl \
        --enable-libtiff \
        --enable-libjpeg \
        --enable-libpng \
        --enable-poppler-glib \
        --enable-poppler-cpp \
        --enable-cairo-output \
        --enable-splash-output \
        --enable-compile-warnings=yes \
        --enable-introspection=auto \
        --disable-libopenjpeg \
        --disable-gtk-test \
        --disable-utils \
        --disable-gtk-doc \
        --disable-gtk-doc-html \
        --disable-gtk-doc-pdf \
        --with-font-configuration=win32 \
        PKG_CONFIG_PATH_$(subst -,_,$(TARGET))='$(HOST_PREFIX)/qt/lib/pkgconfig' \
        LIBS="`'$(MXE_PKG_CONFIG)' zlib liblzma --libs` -ljpeg"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # Test program
    '$(MXE_CXX)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cxx' -o '$(HOST_BINDIR)/test-poppler.exe' \
        `'$(MXE_PKG_CONFIG)' poppler poppler-cpp --cflags --libs`
endef

