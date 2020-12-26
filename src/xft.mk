# This file is part of MXE.
# See index.html for further information.

PKG             := xft
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.2
$(PKG)_CHECKSUM := e025d790a7b6c4d283a78d8df06615cb10278e2d
$(PKG)_SUBDIR   := libXft-$($(PKG)_VERSION)
$(PKG)_FILE     := libXft-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
ifeq ($(USE_SYSTEM_FONTCONFIG),no)
  $(PKG)_FONTCONFIG := fontconfig
endif
$(PKG)_DEPS     := kbproto xrender $($(PKG)_FONTCONFIG) freetype

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
