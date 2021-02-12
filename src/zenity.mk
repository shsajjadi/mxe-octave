# This file is part of MXE.
# See index.html for further information.

PKG             := zenity
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.0
$(PKG)_CHECKSUM := af083691820970ef1e79590df35ea5c59a7491f3
$(PKG)_SUBDIR   := zenity-$($(PKG)_VERSION)
$(PKG)_FILE     := zenity-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/zenity/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gtk3 libxml2 itstool

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/zenity/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep -v '^3\.9' | \
    grep '^3\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
	PKG_CONFIG='$(MXE_PKG_CONFIG)' \
	PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install noinst_PROGRAMS=
endef
