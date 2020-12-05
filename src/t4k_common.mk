# This file is part of MXE.
# See index.html for further information.

PKG             := t4k_common
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.1
$(PKG)_CHECKSUM := 626eddedee86059ccab593a226c8d98571018b46
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tuxmath/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := sdl sdl_mixer sdl_image sdl_net sdl_pango sdl_ttf libpng librsvg libxml2 pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/tuxmath/files/$(PKG)/' | \
    $(SED) -n 's,.*t4k_common-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-sdlpango \
        --with-sdlnet \
        --with-rsvg
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
