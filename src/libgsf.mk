# This file is part of MXE.
# See index.html for further information.

PKG             := libgsf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14.30
$(PKG)_CHECKSUM := 5eb15d574c6b9e9c5e63bbcdff8f866b3544485a
$(PKG)_SUBDIR   := libgsf-$($(PKG)_VERSION)
$(PKG)_FILE     := libgsf-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgsf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib bzip2 glib libxml2

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    $(PKG)_DEPS += intltool
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- https://github.com/GNOME/libgsf/tags | \
    $(SED) -n 's|.*releases/tag/LIBGSF_\([^"]*\).*|\1|p' | \
    $(SED) 's,_,.,g' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    echo 'Libs.private: -lz -lbz2'          >> '$(1)'/libgsf-1.pc.in
    #$(SED) -i 's,^\(Requires:.*\),\1 gio-2.0,' '$(1)'/libgsf-1.pc.in
    $(SED) -i 's,\ssed\s, $(SED) ,g'           '$(1)'/gsf/Makefile.in
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-nls \
        --disable-gtk-doc \
	--without-python \
        --with-zlib \
        --with-bz2 \
	--without-gpio \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
	PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' \
	&& $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)'     -j 1 install-pkgconfigDATA DESTDIR='$(3)'
    $(MAKE) -C '$(1)/gsf'     -j '$(JOBS)' 
    $(MAKE) -C '$(1)/gsf' -j 1 install $(MXE_DISABLE_DOCS) $(MXE_DISABLE_PROGS) DESTDIR='$(3)'
endef
