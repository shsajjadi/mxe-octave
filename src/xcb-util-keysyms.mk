# This file is part of MXE.
# See index.html for further information.

PKG             := xcb-util-keysyms
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.0
$(PKG)_CHECKSUM := ff02ee8ac22c53848af50c0a6a6b00feb002c1cb
$(PKG)_SUBDIR   := xcb-util-keysyms-$($(PKG)_VERSION)
$(PKG)_FILE     := xcb-util-keysyms-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/xcb/$($(PKG)_FILE)
$(PKG)_DEPS     := xproto

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
