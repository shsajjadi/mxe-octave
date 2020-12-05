# This file is part of MXE.
# See index.html for further information.

# LibGDA
PKG             := libgda
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.13
$(PKG)_CHECKSUM := 61d0b498202b780750633cc2e957c40325d6c705
$(PKG)_SUBDIR   := libgda-$($(PKG)_VERSION)
$(PKG)_FILE     := libgda-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgda/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := glib libxml2 mdbtools postgresql

define $(PKG)_UPDATE
    echo 'TODO: Updates for package libgda need to be fixed.' >&2;
    echo $(libgda_VERSION)
endef

define $(PKG)_BUILD
    $(SED) -i 's,glib-mkenums,'$(HOST_BINDIR)/glib-mkenums',g' '$(1)/libgda/Makefile.in'
    $(SED) -i 's,glib-mkenums,'$(HOST_BINDIR)/glib-mkenums',g' '$(1)/libgda/sql-parser/Makefile.in'
    $(SED) -i 's,glib-mkenums,'$(HOST_BINDIR)/glib-mkenums',g' '$(1)/libgda-ui/Makefile.in'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-gtk-doc \
        --without-bdb \
        --with-mdb \
        --without-oracle \
        --without-mysql \
        --without-firebird \
        --without-java \
        --enable-binreloc \
        --disable-crypto \
        GLIB_GENMARSHAL='$(HOST_BINDIR)/glib-genmarshal'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
