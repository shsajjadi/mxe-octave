# This file is part of MXE.
# See index.html for further information.

PKG             := pango
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.42.1
$(PKG)_CHECKSUM := 6dbec02a6a35e4cf0be8e1d6748c3d07cd11b7c3
$(PKG)_SUBDIR   := pango-$($(PKG)_VERSION)
$(PKG)_FILE     := pango-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/pango/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
ifeq ($(USE_SYSTEM_FONTCONFIG),no)
  $(PKG)_FONTCONFIG := fontconfig
endif
$(PKG)_DEPS     := $($(PKG)_FONTCONFIG) freetype cairo glib fribidi

define $(PKG)_UPDATE
    $(WGET) -q -O- https://github.com/GNOME/pango/tags | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-gtk-doc \
        CXX='$(MXE_CXX)' \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        PKG_CONFIG_PATH='$(PKG_CONFIG_PATH)' \
        && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install noinst_PROGRAMS= DESTDIR='$(3)'

    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
      rm -rf "$(3)$(HOST_PREFIX)/share/gtk-doc"; \
    fi
endef
