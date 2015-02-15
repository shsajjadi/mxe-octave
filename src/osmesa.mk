# This file is part of MXE Octave.
# See index.html for further information.

PKG             := osmesa
$(PKG)_VERSION  := 10.2.2
$(PKG)_CHECKSUM := 2cc7c5b80fd2ddbf540acf47dbaec68e8cab16a4
$(PKG)_SUBDIR   := Mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := MesaLib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.freedesktop.org/pub/mesa/current/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)' && autoreconf
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --enable-osmesa --disable-dri --without-gallium-drivers --disable-egl \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'
endef
