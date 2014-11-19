# This file is part of MXE.
# See index.html for further information.

PKG             := xt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.4
$(PKG)_CHECKSUM := a691f0ddf664e21b12781ea0724297cd063a3452
$(PKG)_SUBDIR   := libXt-$($(PKG)_VERSION)
$(PKG)_FILE     := libXt-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://xorg.freedesktop.org/archive/individual/lib/$($(PKG)_FILE)
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
