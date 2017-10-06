# This file is part of MXE.
# See index.html for further information.

PKG             := x11
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.2
$(PKG)_CHECKSUM := 351ae5bad88bb2b54b7f749f6096b518a3b13b29
$(PKG)_SUBDIR   := libX11-$($(PKG)_VERSION)
$(PKG)_FILE     := libX11-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://xorg.freedesktop.org/archive/individual/lib/$($(PKG)_FILE)
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
