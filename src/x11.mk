# This file is part of MXE.
# See index.html for further information.

PKG             := x11
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.5
$(PKG)_CHECKSUM := c32155467508dfe783f9296ef22ee6ed53cae7df
$(PKG)_SUBDIR   := libX11-$($(PKG)_VERSION)
$(PKG)_FILE     := libX11-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := inputproto kbproto xcb xextproto xproto xtrans

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
