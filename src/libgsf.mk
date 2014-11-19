# This file is part of MXE.
# See index.html for further information.

PKG             := libgsf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14.27
$(PKG)_CHECKSUM := b6082b71bf9d6e1cdafde9628cae58fcedc4a8fd
$(PKG)_SUBDIR   := libgsf-$($(PKG)_VERSION)
$(PKG)_FILE     := libgsf-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgsf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib bzip2 glib libxml2

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    $(PKG)_DEPS += intltool
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/libgsf/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=LIBGSF_\\([0-9]*_[0-9]*[02468]_[^<]*\\)'.*,\\1,p" | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    echo 'Libs.private: -lz -lbz2'          >> '$(1)'/libgsf-1.pc.in
    $(SED) -i 's,^\(Requires:.*\),\1 gio-2.0,' '$(1)'/libgsf-1.pc.in
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-nls \
        --disable-gtk-doc \
        --with-zlib \
        --with-bz2 \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
	PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' \
	&& $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)'     -j '$(JOBS)'
    $(MAKE) -C '$(1)'     -j 1         install
endef
