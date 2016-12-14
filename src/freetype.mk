# This file is part of MXE.
# See index.html for further information.

PKG             := freetype
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7
$(PKG)_CHECKSUM := f251029d5ab542a96dd4531605fe577185077560
$(PKG)_SUBDIR   := freetype-$($(PKG)_VERSION)
$(PKG)_FILE     := freetype-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freetype/freetype2/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/freetype/files/freetype2/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && GNUMAKE=$(MAKE) ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' 
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'

    rm -f '$(3)$(HOST_LIBDIR)/libfreetype.la'
endef
