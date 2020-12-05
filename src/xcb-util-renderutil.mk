# This file is part of MXE.
# See index.html for further information.

PKG             := xcb-util-renderutil
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.3.9
$(PKG)_CHECKSUM := cb533b1d039f833f070e7d6398c221a31d30d5e2
$(PKG)_SUBDIR   := xcb-util-renderutil-$($(PKG)_VERSION)
$(PKG)_FILE     := xcb-util-renderutil-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/xcb/$($(PKG)_FILE)
$(PKG)_DEPS     := xcb

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
