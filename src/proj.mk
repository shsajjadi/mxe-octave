# This file is part of MXE.
# See index.html for further information.

PKG             := proj
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.1.1
$(PKG)_CHECKSUM := ee93221256b7359700d59479a8097c2f39f9f984
$(PKG)_SUBDIR   := proj-$($(PKG)_VERSION)
$(PKG)_FILE     := proj-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/proj/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/proj/$($(PKG)_FILE)
$(PKG)_DEPS     := sqlite

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://proj.org/download.html' | \
    $(SED) -n 's,.*proj-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    if [ $(MXE_SYSTEM) = msvc ]; then \
	mkdir '$(1)/m4'; \
        cd '$(1)' && autoreconf -f -i -v; \
    fi
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-mutex \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    # remove header which is not installed since 4.8.0
    rm -f '$(HOST_INCDIR)/projects.h'
    $(MAKE) -C '$(1)' -j 1 install
endef
