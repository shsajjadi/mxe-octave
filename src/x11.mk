# This file is part of MXE.
# See index.html for further information.

PKG             := x11
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.7
$(PKG)_CHECKSUM := 5076f7853713d7db958a05f6fd1c18f7e111a0ad
$(PKG)_SUBDIR   := libX11-$($(PKG)_VERSION)
$(PKG)_FILE     := libX11-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := inputproto kbproto xcb xextproto xproto xtrans

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.x.org/archive/individual/lib/' | \
    $(SED) -n 's,.*<a href="libX11-\([0-9\.]*\)\.tar.gz".*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

ifeq ($(MXE_WINDOWS_BUILD),yes)
  define $(PKG)_BUILD
  endef
else
  define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'
  endef
endif
