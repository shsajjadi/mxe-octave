# This file is part of MXE.
# See index.html for further information.

PKG             := xt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.5
$(PKG)_CHECKSUM := c79e2c4f7de5259a2ade458817a139b66a043d59
$(PKG)_SUBDIR   := libXt-$($(PKG)_VERSION)
$(PKG)_FILE     := libXt-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := sm ice x11 xproto kbproto

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
