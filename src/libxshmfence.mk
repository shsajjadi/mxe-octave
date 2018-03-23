# This file is part of MXE.
# See index.html for further information.

PKG             := libxshmfence
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3
$(PKG)_CHECKSUM := 3472218fc0e8ee8183533d22dbcd4bbe90bf3ab8
$(PKG)_SUBDIR   := libxshmfence-$($(PKG)_VERSION)
$(PKG)_FILE     := libxshmfence-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := xproto

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.x.org/archive/individual/lib/' | \
    $(SED) -n 's|.*href="libxshmfence-\([0-9\.]*\).tar.*|\1|p' | $(SORT) -V | \
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
