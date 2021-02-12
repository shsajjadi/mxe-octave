# This file is part of MXE.
# See index.html for further information.

PKG             := libxslt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.27
$(PKG)_CHECKSUM := f8072177f1ffe1b9bb8759a9e3e6349e1eac1f66
$(PKG)_SUBDIR   := libxslt-$($(PKG)_VERSION)
$(PKG)_FILE     := libxslt-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://xmlsoft.org/libxslt/$($(PKG)_FILE)
$(PKG)_DEPS     := libxml2 libgcrypt

define $(PKG)_UPDATE
    $(WGET) -q -O- https://github.com/GNOME/libxslt/tags | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --without-debug \
        --prefix='$(HOST_PREFIX)' \
        --with-libxml-prefix='$(HOST_PREFIX)' \
        LIBGCRYPT_CONFIG='$(HOST_BINDIR)/libgcrypt-config' \
        --without-python \
        --without-plugins
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
