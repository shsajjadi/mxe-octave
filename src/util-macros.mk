# This file is part of MXE.
# See index.html for further information.

PKG             := util-macros
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19.1
$(PKG)_CHECKSUM := 386e993ba339e561aa6d93073a4dcbab24e30bad
$(PKG)_SUBDIR   := util-macros-$($(PKG)_VERSION)
$(PKG)_FILE     := util-macros-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/util/$($(PKG)_FILE)
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
