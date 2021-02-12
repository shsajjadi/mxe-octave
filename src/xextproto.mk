# This file is part of MXE.
# See index.html for further information.

PKG             := xextproto
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.3.0
$(PKG)_CHECKSUM := b8d736342dcb73b71584d99a1cb9806d93c25ff8
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/proto/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.x.org/archive/individual/proto/' | \
    $(SED) -n 's,.*<a href="xextproto-\([0-9\.]*\)\.tar.gz".*,\1,p' | \
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
