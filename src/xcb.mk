# This file is part of MXE.
# See index.html for further information.

PKG             := xcb
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12
$(PKG)_CHECKSUM := 2f03490d1c75c8a3f902f74b717af6501773926a
$(PKG)_SUBDIR   := libxcb-$($(PKG)_VERSION)
$(PKG)_FILE     := libxcb-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/xcb/$($(PKG)_FILE)
$(PKG)_DEPS     := pthread-stubs util-macros xau xcb-proto

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
