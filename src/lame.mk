# This file is part of MXE.
# See index.html for further information.

http://downloads.sourceforge.net/project/lame/lame

PKG             := lame
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.100
$(PKG)_CHECKSUM := 64c53b1a4d493237cef5e74944912cd9f98e618d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := libiconv gettext termcap

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/lame/files/lame/3.100' | \
    $(SED) -n 's,.*lame-\([0-9][0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-frontend
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)' $(MXE_DISABLE_DOCS)
endef
