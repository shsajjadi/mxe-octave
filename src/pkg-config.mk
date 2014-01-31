# This file is part of MXE.
# See index.html for further information.

PKG             := pkg-config
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.28
$(PKG)_CHECKSUM := 71853779b12f958777bffcb8ca6d849b4d3bed46
$(PKG)_SUBDIR   := pkg-config-$($(PKG)_VERSION)
$(PKG)_FILE     := pkg-config-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://pkgconfig.freedesktop.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

# native mingw needs to be told an architechure for the internal glib to build
ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  $(PKG)_CONFIG_OPTS := CPPFLAGS='-march=i486' LN=$(LN)
endif

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1)' && autoreconf
    cd '$(1).build' && '$(1)/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --with-internal-glib \
        --with-libiconv=gnu \
        $($(PKG)_CONFIG_OPTS) \
        --with-pc_path='$(HOST_LIBDIR)/pkgconfig' \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1).build' V=1 -j 1
    $(MAKE) -C '$(1).build' -j 1 install DESTDIR='$(3)'
endef
