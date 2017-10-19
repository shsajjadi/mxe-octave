# This file is part of MXE.
# See index.html for further information.

PKG             := xcursor
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.14
$(PKG)_CHECKSUM := 89870756758439f9216ddf5f2d3dca56570fc6b7
$(PKG)_SUBDIR   := libXcursor-$($(PKG)_VERSION)
$(PKG)_FILE     := libXcursor-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := fixesproto x11 xfixes xrender

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
