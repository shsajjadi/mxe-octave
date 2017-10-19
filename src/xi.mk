# This file is part of MXE.
# See index.html for further information.

PKG             := xi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.9
$(PKG)_CHECKSUM := 70d1148c39c0eaa7d7c18370f20709383271f669
$(PKG)_SUBDIR   := libXi-$($(PKG)_VERSION)
$(PKG)_FILE     := libXi-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := inputproto xext xextproto xproto x11

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
