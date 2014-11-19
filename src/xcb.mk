# This file is part of MXE.
# See index.html for further information.

PKG             := xcb
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11
$(PKG)_CHECKSUM := 69a2f447a10918d005c33a8391492d0443533df7
$(PKG)_SUBDIR   := libxcb-$($(PKG)_VERSION)
$(PKG)_FILE     := libxcb-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://xorg.freedesktop.org/archive/individual/xcb/$($(PKG)_FILE)
$(PKG)_DEPS     := pthread-stubs xau xcb-proto

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
