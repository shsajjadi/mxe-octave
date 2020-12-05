# This file is part of MXE.
# See index.html for further information.

PKG             := xdamage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.4
$(PKG)_CHECKSUM := c3fc0f4b02dce2239bf46c82a5f06b06585720ae
$(PKG)_SUBDIR   := libXdamage-$($(PKG)_VERSION)
$(PKG)_FILE     := libXdamage-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
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
