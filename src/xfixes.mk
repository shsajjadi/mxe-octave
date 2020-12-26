# This file is part of MXE.
# See index.html for further information.

PKG             := xfixes
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.3
$(PKG)_CHECKSUM := ca86342d129c02435a9ee46e38fdf1a04d6b4b91
$(PKG)_SUBDIR   := libXfixes-$($(PKG)_VERSION)
$(PKG)_FILE     := libXfixes-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := fixesproto xextproto xproto x11

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
