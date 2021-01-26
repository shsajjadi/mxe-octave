# This file is part of MXE.
# See index.html for further information.

PKG             := proj
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.2.1
$(PKG)_CHECKSUM := 593005f2e4e76575ebee5cf228c968be730f9fd3
$(PKG)_SUBDIR   := proj-$($(PKG)_VERSION)
$(PKG)_FILE     := proj-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/proj/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/proj/$($(PKG)_FILE)
$(PKG)_DEPS     := curl sqlite tiff

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
