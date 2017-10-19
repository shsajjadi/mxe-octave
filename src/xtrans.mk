# This file is part of MXE.
# See index.html for further information.

PKG             := xtrans
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.5
$(PKG)_CHECKSUM := 2d3ae1839d841f568bc481c6116af7d2a9f9ba59
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := 

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

    mv '$(3)/$(HOST_PREFIX)/share/pkgconfig/xtrans.pc' '$(HOST_PREFIX)/lib/pkgconfig/xtrans.pc'
  endef
endif
