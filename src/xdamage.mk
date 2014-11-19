# This file is part of MXE.
# See index.html for further information.

PKG             := xdamage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.4
$(PKG)_CHECKSUM := f357e25af6fe05ae76af2acf2250969652f3a1b0
$(PKG)_SUBDIR   := libXdamage-$($(PKG)_VERSION)
$(PKG)_FILE     := libXdamage-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://xorg.freedesktop.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := damageproto xfixes fixesproto xextproto x11

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
