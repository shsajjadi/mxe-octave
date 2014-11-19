# This file is part of MXE.
# See index.html for further information.

PKG             := xft
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.2
$(PKG)_CHECKSUM := 0568a360a9f3ca97bdcdaf61535bf9d0bdae80db
$(PKG)_SUBDIR   := libXft-$($(PKG)_VERSION)
$(PKG)_FILE     := libXft-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://xorg.freedesktop.org/releases/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := kbproto xrender fontconfig freetype

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
