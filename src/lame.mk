# This file is part of MXE.
# See index.html for further information.

PKG             := lame
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.99.5
$(PKG)_CHECKSUM := 03a0bfa85713adcc6b3383c12e2cc68a9cfbf4c4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := libiconv gettext

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/lame/files/lame/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -i -I '$(HOST_PREFIX)/share/aclocal' && \
        ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-frontend
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)' $(MXE_DISABLE_DOCS)
endef
