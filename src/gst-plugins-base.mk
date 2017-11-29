# This file is part of MXE.
# See index.html for further information.

PKG             := gst-plugins-base
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.36
$(PKG)_CHECKSUM := 2c4b34245107395bc9103649bb2af1c1088a3f7c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := glib libxml2 gstreamer liboil pango ogg vorbis theora

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cgit.freedesktop.org/gstreamer/gst-plugins-base/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    find '$(1)' -name Makefile.in \
        -exec $(SED) -i 's,glib-mkenums,$(HOST_BINDIR)/glib-mkenums,g'       {} \; \
        -exec $(SED) -i 's,glib-genmarshal,$(HOST_BINDIR)/glib-genmarshal,g' {} \;
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-debug \
        --disable-examples \
        --disable-x \
        --mandir='$(1)/sink' \
        --docdir='$(1)/sink' \
        --with-html-dir='$(1)/sink'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
