# This file is part of MXE.
# See index.html for further information.

PKG             := transfig
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 27aa9691bf84f8775db9be39c453a8132148bad1
$(PKG)_SUBDIR   := $(PKG).$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG).$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mcj/mcj-source/$($(PKG)_FILE)
$(PKG)_DEPS     := jpeg libpng

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && chmod 755 configure && aclocal && automake --add-missing && autoconf \
        && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        BITMAPDIR="/share/$(PKG)/bitmaps" \
        RGB_FILE="/share/$(PKG)/rgb.txt" \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' 

    $(MAKE) -C '$(1)' -j '$(JOBS)' 
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'
endef
