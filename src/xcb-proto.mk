# This file is part of MXE.
# See index.html for further information.

PKG             := xcb-proto
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.13
$(PKG)_CHECKSUM := f7fa35ab59af18cecadbe83fe705281dcfd82ffd
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/xcb/$($(PKG)_FILE)
$(PKG)_DEPS     := 


define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.x.org/archive/individual/xcb/' | \
    $(SED) -n 's,.*<a href="xcb-proto-\([0-9\.]*\)\.tar.gz".*,\1,p' | \
    $(SORT) -V |
    tail -1
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
