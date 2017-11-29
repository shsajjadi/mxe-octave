# This file is part of MXE.
# See index.html for further information.

PKG             := gst-plugins-good
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.31
$(PKG)_CHECKSUM := 15addda7c6322a42c904aaf1c1d0b5d5a63f908b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := glib libxml2 gstreamer gst-plugins-base liboil libshout cairo flac gtk2 jpeg libpng speex taglib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cgit.freedesktop.org/gstreamer/gst-plugins-good/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    find '$(1)' -name Makefile.in \
        -exec $(SED) -i 's,glib-mkenums,$(HOST_BINDIR)/glib-mkenums,g'       {} \; \
        -exec $(SED) -i 's,glib-genmarshal,$(HOST_BINDIR)/glib-genmarshal,g' {} \;
    # The value for WAVE_FORMAT_DOLBY_AC3_SPDIF comes from vlc and mplayer:
    #   http://www.videolan.org/developers/vlc/doc/doxygen/html/vlc__codecs_8h-source.html
    #   http://lists.mplayerhq.hu/pipermail/mplayer-cvslog/2004-August/019283.html
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-debug \
        --disable-examples \
        --disable-aalib \
        --disable-x \
        --mandir='$(1)/sink' \
        --docdir='$(1)/sink' \
        --with-html-dir='$(1)/sink'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install CFLAGS='-DWAVE_FORMAT_DOLBY_AC3_SPDIF=0x0092'
endef
