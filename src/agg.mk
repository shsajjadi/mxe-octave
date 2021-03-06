# This file is part of MXE.
# See index.html for further information.

PKG             := agg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5
$(PKG)_CHECKSUM := 08f23da64da40b90184a0414369f450115cdb328
$(PKG)_SUBDIR   := agg-$($(PKG)_VERSION)
$(PKG)_FILE     := agg-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://web.archive.org/20150812005010/http://www.antigrain.com/$($(PKG)_FILE)
$(PKG)_DEPS     := freetype sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://web.archive.org/20150812005010/http://www.antigrain.com/download/index.html' | \
    $(SED) -n 's,.*www.antigrain.com/agg-\([0-9.]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,aclocal,aclocal -I $(HOST_PREFIX)/share/aclocal,' '$(1)/autogen.sh'
    $(SED) -i 's,libtoolize,$(LIBTOOLIZE),'                             '$(1)/autogen.sh'
    cd '$(1)' && $(SHELL) ./autogen.sh \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
