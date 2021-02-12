# This file is part of MXE.
# See index.html for further information.

PKG             := libglade
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.4
$(PKG)_CHECKSUM := 3cc65ed13c10025780488935313329170baa33c6
$(PKG)_SUBDIR   := libglade-$($(PKG)_VERSION)
$(PKG)_FILE     := libglade-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/libglade/2.6/$($(PKG)_FILE)
$(PKG)_DEPS     := libxml2 atk glib gtk2

define $(PKG)_UPDATE
    wget -q -O- 'http://ftp.gnome.org/pub/GNOME/sources/libglade/2.6/' | \
    $(SED) -n 's,.*"libglade-\([0-9][^"]*\)\.tar.gz.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        PKG_CONFIG='$(MXE_PKG_CONFIG)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install-exec
endef
