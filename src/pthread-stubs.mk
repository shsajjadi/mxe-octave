# This file is part of MXE.
# See index.html for further information.

PKG             := pthread-stubs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3
$(PKG)_CHECKSUM := 7174d6a5f4b158746f020b8fc7a3e3e5438dd233
$(PKG)_SUBDIR   := libpthread-stubs-$($(PKG)_VERSION)
$(PKG)_FILE     := libpthread-stubs-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://xcb.freedesktop.org/dist/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
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
